# Runs the Fuseki SPARQL server against TDB

if [ "$FUSEKI_HOME" == '' ]; then
  echo -e "\n\n\tCreate your version of init.sh and run it with '. my_init.sh'\n"
  exit 1
fi

export WDIR=$(pwd)
cd $(dirname $0)
export MYDIR=$(pwd)

echo -e "\n\tLaunching Fuseki, the SPARQL endpoint will be at http://localhost:3030"
"$FUSEKI_HOME/fuseki-server" --loc=tdb /ds
