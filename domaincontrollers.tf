/*
  Domain Controllers
*/
resource "aws_security_group" "dc" {
    name = "sg_acc-stack-dc"
    description = "Allow incoming RDP connections."

    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        security_groups = ["${aws_security_group.jumphost.id}"]
    }
    ingress {
        from_port = 389
        to_port = 389
        protocol = "tcp"
        cidr_blocks = ["${var.company_network}"]
    }
    ingress {
        from_port = 3268
        to_port = 3268
        protocol = "tcp"
        cidr_blocks = ["${var.company_network}"]
    }
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "sg_acc-stack-uw2-dc"
    }
}

resource "aws_instance" "dc01" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.dc.id}"]
    subnet_id = "${aws_subnet.subnet-pri-uw2a.id}"
    tags {
        Name = "acc-stack-dc01"
    }
}

resource "aws_instance" "dc02" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.aws_instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.dc.id}"]
    subnet_id = "${aws_subnet.subnet-pri-uw2b.id}"
    tags {
        Name = "acc-stack-dc02"
    }
}
