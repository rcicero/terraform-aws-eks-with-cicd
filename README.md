ROLE="    - rolearn: arn:aws:iam::410017455363:policy/eks-describe\n      username: build\n      groups:\n        - system:masters" 
kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > /tmp/aws-auth-patch.yml
kubectl patch configmap/aws-auth -n kube-system --patch "$(cat /tmp/aws-auth-patch.yml)"

- next -> ci/cd

