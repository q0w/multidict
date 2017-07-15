if [ ! -z $TRAVIS_TAG ]; then
    package_name="$1"
    if [ -z "$package_name" ]
    then
        &>2 echo "Please pass package name as a first argument of this script ($0)"
        exit 1
    fi

    echo "x86_64"
    docker pull quay.io/pypa/manylinux1_x86_64
    docker run --rm -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/tools/build-wheels.sh
    echo "Dist folder content is:"
    for f in dist/*manylinux1_x86_64.whl
    do
        echo "Upload $f"
        python -m twine upload $f --username andrew.svetlov --password $PYPI_PASSWD
    done
    echo "Cleanup"
    docker run --rm -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 rm -rf /io/dist

    echo "i686"
    docker pull quay.io/pypa/manylinux1_i686
    docker run --rm -v `pwd`:/io quay.io/pypa/manylinux1_i686 linux32 /io/tools/build-wheels.sh "$package_name"
    echo "Dist folder content is:"
    for f in dist/*manylinux1_i686.whl
    do
        echo "Upload $f"
        python -m twine upload $f --username andrew.svetlov --password $PYPI_PASSWD
    done
    echo "Cleanup"
    docker run --rm -v `pwd`:/io quay.io/pypa/manylinux1_i686 rm -rf /io/dist
fi