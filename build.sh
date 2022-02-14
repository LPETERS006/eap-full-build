for d in */
do
    iv=$(echo -n $d | head -c -1)
    (cd "$d" && docker build --force-rm --no-cache -t $iv . && \
	    docker tag $iv:latest lpeters999/eap-full-ci:$iv && docker tag $iv:latest lpeters999/eap-full-ci:latest-$iv && \
        docker push lpeters999/eap-full-ci:$iv && docker push lpeters999/eap-full-ci:latest-$iv)
done
