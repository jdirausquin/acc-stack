resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = false
    tags {
        Name = "vpc-acc-stack-001"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.vpc.id}"
}

/*
  Public Subnets
*/
resource "aws_subnet" "subnet-pub-uw2a" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pub_cidr_a}"
    availability_zone = "us-west-2a"

    tags {
        Name = "subnet-acc-stack-pub-uw2a"
    }
}

resource "aws_subnet" "subnet-pub-uw2b" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.subnet_pub_cidr_b}"
    availability_zone = "us-west-2b"

    tags {
        Name = "subnet-acc-stack-pub-uw2b"
    }
}

resource "aws_route_table" "rtb-pub" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.vpc.id}"
    }
    tags {
        Name = "rtb-acc-stack-pub"
    }
}

resource "aws_route_table_association" "uw2a-pub" {
    subnet_id = "${aws_subnet.subnet_pub_cidr_a}"
    route_table_id = "${aws_route_table.rtb-pub.id}"
}

resource "aws_route_table_association" "uw2b-pub" {
    subnet_id = "${aws_subnet.subnet_pub_cidr_b}"
    route_table_id = "${aws_route_table.rtb-pub.id}"
}

/*
  Private Subnets
*/

resource "aws_subnet" "subnet-priv-uw2a" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_pri_cidr_a}"
    availability_zone = "us-west-2a"
    tags {
        Name = "subnet-acc-stack-pri-uw2a"
    }
}

resource "aws_subnet" "subnet-priv-uw2b" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_pri_cidr_b}"
    availability_zone = "us-west-2b"
    tags {
        Name = "subnet-acc-stack-pri-uw2b"
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
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }
    tags {
        Name = "rtb-acc-stack-pri"
    }
}

resource "aws_route_table_association" "uw2a-pri" {
    subnet_id = "${aws_subnet.subnet_pri_cidr_a.id}"
    route_table_id = "${aws_route_table.rtb-pri.id}"
}

resource "aws_route_table_association" "uw2b-pri" {
    subnet_id = "${aws_subnet.subnet_pri_cidr_b.id}"
    route_table_id = "${aws_route_table.rtb-pri.id}"
}