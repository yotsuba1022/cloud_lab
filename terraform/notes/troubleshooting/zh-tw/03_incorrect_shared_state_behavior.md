# Terraform State 管理錯誤導致的資源異動問題

[English](../en/03_incorrect_shared_state_behavior.md) | [繁體中文](03_incorrect_shared_state_behavior.md) | [日本語](../ja/03_incorrect_shared_state_behavior.md) | [返回索引](../README.md)

---

## 背景
- 實驗日期：2025/05/24
- 難度：🤬🤬
- 描述：使用 Terraform 管理多模組（`infra-networking` 與 `isolated-ec2`）時，未正確劃分 backend，導致彼此狀態重疊並誤刪資源。

---

## 遇到的現象

- `infra-networking` 成功 apply，且在 AWS Console 中能清楚看到建立好的資源（VPC、Subnet、Route Table 等）
- 接著執行 `isolated-ec2` 的 `terraform plan`，Terraform 卻試圖移除剛剛 `infra-networking` 所建立的資源
- 這與我們預期「疊加」的狀態管理方式不同，反而像是兩個模組同時操作同一份 context

---

## 錯誤示意架構圖

### ❌ infra-network 與 isolated-ec2 共用同一個 terraform state

```
📁 terraform-state/
└── dev-backend.hcl     --> 提供共用 backend

📁 infra-network/
└── main.tf             --> 使用 dev-backend.hcl

📁 isolated-ec2/
└── main.tf             --> 也使用 dev-backend.hcl

📦 AWS S3
└── key = dev/terraform.tfstate
    └── state 包含 infra + ec2 的所有資源
```

```
          +-----------------------------+
          |  S3: dev/terraform.tfstate  |
          +-----------------------------+
                  ▲          ▲
                  |          |
       +----------+          +----------+
       |                                |
+---------------+             +------------------+
| infra-network |             |  isolated-ec2    |
+---------------+             +------------------+
(共享同一個 state，互相影響)
```

---

## 修正後的做法

### ✅ infra-network 與 isolated-ec2 使用獨立的 terraform state

```
📁 terraform-state/
├── dev-infra.hcl       --> 給 infra-network 用
└── dev-ec2.hcl         --> 給 isolated-ec2 用

📁 infra-network/
└── main.tf             --> 使用 dev-infra.hcl

📁 isolated-ec2/
└── main.tf             --> 使用 dev-ec2.hcl

📦 AWS S3
├── key = dev/infra/terraform.tfstate
└── key = dev/ec2/terraform.tfstate
```

```
          +---------------------------------+       +--------------------------------+
          | S3: dev/infra/terraform.tfstate |       | S3: dev/ec2/terraform.tfstate  |
          +---------------------------------+       +--------------------------------+
                           ▲                                        ▲
                           |                                        |
                           |                                        |
                   +---------------+                       +------------------+
                   | infra-network |                       |  isolated-ec2    |
                   +---------------+                       +------------------+
                                      (彼此獨立，不互相影響)
```

---

## 除錯過程

- 最初只建立了 `infra-networking` 的 backend 設定檔，且成功將狀態寫入 S3
- 但 `isolated-ec2` 沒有自己的 backend 設定檔，導致 terraform init 時沿用預設（或重複使用 dev-backend.hcl）
- Terraform 誤以為整個 state 都歸 isolated-ec2 所有，因此打算「同步」成 isolated-ec2 的狀態（也就是刪除 infra 的東西）

---

## 解決方式

1. 為 `isolated-ec2` 建立專屬的 backend 設定檔（hcl）
2. 採用腳本自動產生 backend 設定，並依照環境與模組命名規則存放
3. backend 狀態檔配置獨立的 key 與 DynamoDB Lock Table，避免與其他模組衝突
4. 修正後再次 `terraform init` → `plan`，就不再出現刪除其他模組資源的錯誤

---

## 說明補充

此處的 backend 設定採用了「以環境 + 模組」為基礎的獨立資料夾儲存方式，並透過 shell 腳本自動生成對應的 `backend.hcl`。這樣的方式能大幅降低出錯機率，也便於後續維護。

此自動產生 backend 的腳本會於 terraform/envs 資料夾內的 [README](../../../envs/README.md) 說明。

---

## 小結

若 Terraform 中多個模組共享相同的 backend 設定而未做區隔，就可能發生交叉誤刪、資源重建的情況。

總而言之：**狀態檔的劃分與管理，是多模組基礎架構設計中的關鍵一環**。
