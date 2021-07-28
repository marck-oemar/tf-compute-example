data "aws_caller_identity" "current" {}

resource "aws_iam_role" "testvm" {
  # this must be fixed name, not prefix for IAM purpose
  name               = "tf-testvm-${var.env}"
  assume_role_policy = "${data.template_file.assume-role-policy.rendered}"
}

resource "aws_iam_instance_profile" "testvm" {
  name = "tf-testvm-${var.env}"
  role = "${aws_iam_role.testvm.name}"
}

data "template_file" "assume-role-policy" {
  vars = {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }

  template = "${file("${path.module}/policies/assume-role-policy.json.tmpl")}"
}

data "template_file" "policy-base-testvm" {
  template = "${file("${path.module}/policies/base.json.tmpl")}"
}

resource "aws_iam_policy" "policy-base-testvm" {
  name_prefix = "tf-base-testvm-${var.env}"
  policy      = "${data.template_file.policy-base-testvm.rendered}"
}

resource "aws_iam_role_policy_attachment" "base-testvm" {
  role       = "${aws_iam_role.testvm.name}"
  policy_arn = "${aws_iam_policy.policy-base-testvm.arn}"
}

resource "aws_iam_role_policy_attachment" "admin-testvm" {
  role       = "${aws_iam_role.testvm.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
