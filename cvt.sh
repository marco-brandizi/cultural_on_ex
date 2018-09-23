# Converts input files into RDF and prepares the Fuseki triple store into tdb/
# 
if [ "$JENA_HOME" == '' ]; then
  echo -e "\n\n\tCreate your version of init.sh and run it with '. my_init.sh'\n"
  exit 1
fi

export WDIR=$(pwd)
cd $(dirname $0)
export MYDIR=$(pwd)

echo -e "\n\tCleaning data_out/ and tdb/"
rm -Rf data_out/* tdb

echo -e "\n\tConverting Lombardia"
"$JENA_HOME/bin/sparql" \
   --graph=data_in/Beni_culturali_Bella_Lombardia.rdf --query=lombardia_trns.sparql \
   >data_out/lombardia.ttl

for mibact_csv in $(ls data_in/regione-*A*.csv)
do
  bname=$(basename "$mibact_csv" .csv)
  echo -e "\n\tConverting $bname"
  "$TARQL_HOME/bin/tarql" --delimiter ';' mibact_trns.tarql "$mibact_csv" >data_out/"$bname".ttl
done

echo -e "\n\tConverting Umbria"
"$TARQL_HOME/bin/tarql" \
  --delimiter ';' umbria_trns.tarql data_in/catalogo_umbria.csv >data_out/catalogo_umbria.ttl

echo -e "\n\tAll conversions done, populating Fuseki"
"$JENA_HOME/bin/tdbloader2" --loc tdb ontos/* data_out/*

echo -e "\n\tThe End, now you can run ./fuseki.sh\n"
