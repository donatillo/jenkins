resource "aws_resourcegroups_group" "resg-jenkins" {
    name = "jenkins"
    description = "Resources built for the jenkins instance."
    
    resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
    {
      "Key": "Creator",
      "Values": ["jenkins"]
    }
  ]
}
JSON
  }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
