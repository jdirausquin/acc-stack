resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = false
    tags {
        Name = "vpc_acc-stack-001"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "igw_acc-stack"
    }
}

/*
  Public Subnets
*/
resource "aws_subnet" "subnet-pub-uw2a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pub_cidr_a}"
    availability_zone = "${var.aws_az_a}"

    tags {
        Name = "subnet_acc-stack-pub-uw2a"
    }
}

resource "aws_subnet" "subnet-pub-uw2b" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pub_cidr_b}"
    availability_zone = "${var.aws_az_b}"

    tags {
        Name = "subnet_acc-stack-pub-uw2b"
    }
}

resource "aws_route_table" "rtb-pub" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
    tags {
        Name = "rtb_acc-stack-pub"
    }
}

resource "aws_route_table_association" "uw2a-pub" {
    subnet_id = "${aws_subnet.subnet-pub-uw2a.id}"
    route_table_id = "${aws_route_table.rtb-pub.id}"
}

resource "aws_route_table_association" "uw2b-pub" {
    subnet_id = "${aws_subnet.subnet-pub-uw2b.id}"
    route_table_id = "${aws_route_table.rtb-pub.id}"
}

/*
  Private Subnets
*/

resource "aws_subnet" "subnet-pri-uw2a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pri_cidr_a}"
    availability_zone = "${var.aws_az_a}"
    tags {
        Name = "subnet-acc-stack-pri-uw2a"
    }
}

resource "aws_subnet" "subnet-pri-uw2b" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pri_cidr_b}"
    availability_zone = "${var.aws_az_b}"
    tags {
        Name = "subnet_acc-stack-pri-uw2b"
    }
}

resource "aws_eip" "nat_eip" {
    vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.subnet-pub-uw2a.id}"
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "rtb-pri" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }
    tags {
        Name = "rtb_acc-stack-pri"
    }
}

resource "aws_route_table_association" "uw2a-pri" {
    subnet_id = "${aws_subnet.subnet-pri-uw2a.id}"
    route_table_id = "${aws_route_table.rtb-pri.id}"
}

resource "aws_route_table_association" "uw2b-pri" {
    subnet_id = "${aws_subnet.subnet-pri-uw2b.id}"
    route_table_id = "${aws_route_table.rtb-pri.id}"
}
