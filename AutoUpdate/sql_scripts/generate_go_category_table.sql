create table GO_CATEGORY as select id,acc,'f'as category from term where term_type='molecular_function' and acc like 'GO%';
insert into GO_CATEGORY select id,acc,'p' from term where term_type='biological_process' and acc like 'GO%';
insert into GO_CATEGORY select id,acc,'c' from term where term_type='cellular_component' and acc like 'GO%';
