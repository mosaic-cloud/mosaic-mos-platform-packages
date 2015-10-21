#!/dev/null

cat <<EOS

mosaic-platform-core@package : mosaic-node-boot@package
mosaic-platform-java@package : mosaic-node-boot@package

mosaic-platform-core@publish :
mosaic-platform-java@publish :

mosaic-node-debugging@package :
mosaic-node-debugging@publish :

EOS

exit 0
