/*
  Jump Hosts
*/
resource "aws_security_group" "jumphost" {
    name = "sg-uw2-acc-stack-jh"
    description = "Allow incoming RDP connections."

    ingress {
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress { # RDP
        from_port = 3389
        to_port = 3389
        protocol = "tcp"
        cidr_blocks = ["${var.subnet_pri_cidr_a}", "${var.subnet_pri_cidr_b}"]
    }
    
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "JumpHost"
    }
}

resource "aws_instance" "jh01" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.medium"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jumphost.id}"]
    subnet_id = "${aws_subnet.subnet-pub-uw2a.id}"
    associate_public_ip_address = true
    tags {
        Name = "acc-stack-jh01"
    }
}

resource "aws_eip" "eip_jh01" {
    instance = "${aws_instance.jh01.id}"
    vpc = true
}

resource "aws_instance" "jh02" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.medium"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${aws_security_group.jumphost.id}"]
    subnet_id = "${aws_subnet.subnet-pub-uw2b.id}"
    associate_public_ip_address = true
    tags {
        Name = "acc-stack-jh02"
    }
}

resource "aws_eip" "eip_jh02" {
    instance = "${aws_instance.jh02.id}"
    vpc = true
}