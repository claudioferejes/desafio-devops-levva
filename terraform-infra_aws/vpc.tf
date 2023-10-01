
# Criar uma VPC
resource "aws_vpc" "levva_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "levva_vpc"
  }
}

# Criar sub-redes públicas
resource "aws_subnet" "public_01" {
  vpc_id = aws_vpc.levva_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "Public_01"
  }
}

resource "aws_subnet" "public_02" {
  vpc_id = aws_vpc.levva_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public_02"
  }
}


# Criar sub-redes privadas
resource "aws_subnet" "private_01" {
  vpc_id = aws_vpc.levva_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private_01"
  }
}

resource "aws_subnet" "private_02" {
  vpc_id = aws_vpc.levva_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private_02"
  }
}

# Criar Internet Gateway
resource "aws_internet_gateway" "ig-levva" {
  vpc_id = aws_vpc.levva_vpc.id
}

# Criar rotas para internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.levva_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-levva.id
  }
}

# Associar sub-redes públicas com a tabela de roteamento pública
resource "aws_route_table_association" "public" {
  subnet_id = "aws_subnet.public_01, aws_subnet.public_02"
  route_table_id = aws_route_table.public.id
}

# Criar Security Group
resource "aws_security_group" "levva_nsg" {
  name_prefix = "levva_nsg"
  vpc_id = aws_vpc.levva_vpc.id

  ## Permitir  as portas usadas pelo ECS
  ingress {
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


