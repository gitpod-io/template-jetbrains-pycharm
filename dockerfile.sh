for dockerfile in $(find . -not -path "\./\.*" -name "Dockerfile"); do
	path=$(dirname $dockerfile)
	echo "\033[32mBuilding container flynn/$(basename $path)... \033[39m"
	cd $path && docker build -t flynn/$(basename $path) .
	cd - > /dev/null
done
