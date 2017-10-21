q_toxo="
select max(bs.score) score, chembl_id, target_type, organism, targets.tax_id, targets.targ_comp, site_name
from
(select distinct td.chembl_id, td.target_type, td.organism, td.tax_id, bs.targ_comp, site_name
from blast_statistics bs
, target_components tc
, target_dictionary td
, tax_norm_threshold tnt
, binding_sites bind
where bs.tax_id=508771
  and bs.tax_id = tnt.tax_id
  and bs.score > tnt.threshold
  and bs.expect < .001
  and bs.targ_comp = tc.component_id
  and tc.tid = td.tid
  and bind.tid = tc.tid
  and not exists (select 1
                  from exclude_organisms xo
		  where td.tax_id = xo.tax_id
                 )
) targets
,blast_statistics bs
where bs.targ_comp = targets.targ_comp
group by chembl_id, target_type, organism, targets.tax_id, targets.targ_comp, site_name
order by score desc
"
res=dbSendQuery(con,q_toxo)
toxo_targets=dbFetch(res,n=-1)
