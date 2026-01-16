SELECT 
FROM_UNIXTIME(TM, '%%Y-%%m-%%d %%H:%%i:%%s') as timestamp, 
Pressure_var as p, 
ref_frqUnif_var as f, 
calcPower_var as pf, 
calcPowerRev_var as pr, 
UrfUni_var as urf, 
Ubias_unif_var as ub, 
T0_var as t1, 
T1_var as t2, 
T2_var as t3 
FROM `DBAVl_1s_mysql_<GRP>` 
WHERE TM BETWEEN 
UNIX_TIMESTAMP('%s') 
AND UNIX_TIMESTAMP('%s')
