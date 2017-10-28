library(RPostgreSQL)
drv=dbDriver('PostgreSQL')
con=dbConnect(drv,dbname='chembl_20',port=5432,host='localhost',user='mychembl')

q_toxo_drugs = "select distinct md.pref_name, md.chembl_id, mechanism_of_action, site_name
FROM blast_statistics bs
, tax_norm_threshold t
, target_components tc
, target_dictionary td
, drug_mechanism dm
, molecule_dictionary md
, binding_sites bind
WHERE bs.score > t.threshold
 and bs.tax_id = t.tax_id
 and bs.expect < .001
 and bs.targ_comp = tc.component_id
 and bs.tax_id = 272561
 and bs.tax_id = t.tax_id
 and tc.tid = td.tid
 and bind.tid = tc.tid
 and dm.site_id = bind.site_id
 and md.molregno = dm.molregno
 and not exists (select 1 
		from exclude_organisms eo
		where eo.tax_id = td.tax_id
		)
order by 1"
res=dbSendQuery(con,q_toxo_drugs)
toxo_drugs=dbFetch(res,n=-1)

