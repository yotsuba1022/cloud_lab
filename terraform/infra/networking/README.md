# Infra Network Design

### Structure tree
```
aws_vpc.this
├── aws_internet_gateway.this  ───→ 公共出入口
├── aws_subnet.public[N]
│   └── 綁定 aws_route_table.public → 指定走 IGW
│       └── aws_route.igw
├── aws_subnet.private[N]
│   └── 綁定 aws_route_table.private[N] → 指定走 NAT
│       └── aws_route.nat[N]
├── aws_nat_gateway.this[N]
│   ├── 放在 public subnet
│   └── 用 aws_eip.nat[N] 作為出口位址
```

### Reference sequence and logic
1. aws_vpc.this
 - 每個資源都會依附在某個 VPC 上。這裡的 VPC 是基礎，也是所有其他網路元件的「母體」。

2. aws_internet_gateway.this
 - 跟 VPC 一對一綁定，讓這個 VPC 的 public subnet 有對外的網路出入口。
 - IGW 是一種 AWS 提供的「對外 NAT」設備，給 Public Subnet 用。

3. aws_subnet.public + aws_subnet.private
 - Public Subnet 設定了 map_public_ip_on_launch = true，代表這裡啟動的 EC2 會自動配一個 public IP。
 - 每個 Subnet 指定了一個 AZ，也指定了 CIDR（區域位址範圍）。

4. aws_eip.nat
 - EIP（Elastic IP）= 固定不變的公共 IP 位址
 - AWS 預設給 NAT Gateway 的 IP 是動態的，但如果你想確保 private subnet 每次出去的 IP 是固定的（例如連線到外部資料庫白名單），就要搭配 EIP。
 - 這裡 count = length(var.azs)，意思是為每個 AZ 都準備一個 NAT 用的固定 IP。

5. aws_nat_gateway.this
 - 這是 private subnet 上網的「代理人」，擋在中間。
 - 每個 NAT Gateway：
  - 要用一個 public subnet 當作它的起點（subnet_id = aws_subnet.public[count.index].id）
  - 要綁定一個固定 IP，也就是上面的 EIP。
 - 這是私有子網路能「安全上網」的關鍵。

6. aws_route_table.public + aws_route.igw
 - 建一個「公共區域」的路由表，指定「如果目標是 0.0.0.0/0（全世界），就經由 IGW 出去」。
 - 然後用 aws_route_table_association.public 把這個路由表指定給每個 public subnet。

7. aws_route_table.private + aws_route.nat
 - 為每個 private subnet 各建一張獨立的路由表。
 - 指定「如果要連到外部世界，請透過 NAT Gateway 出去」。
 - 路由表也需要透過 route_table_association 綁定到子網路上。

### Summary
1. VPC 是地 → Subnet 是分區
2. IGW 拉出上網線 → 給 Public 區使用
3. NAT Gateway + EIP 組成 Private 區的「防火牆 + 上網管道」
4. Route Table 只是告訴每個子網路「怎麼出門」
