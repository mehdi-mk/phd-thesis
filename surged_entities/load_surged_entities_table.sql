COPY targetresult (
time,
OOO_SibirInvest,
MAJESTIC_HOSTING_01,
SIA_IT_Services,
_45_136_111_0,
RETHEMHOSTING,
RM_Engineering_LLC,
IP_Volume_inc,
PE_Ivanov_Vitaliy_Sergeevich,
OOO_Network_of_data_centers_Selectel,
JSC_The_First,
Romanenko_Stanislav_Sergeevich,
KINX,
VNPT_Corp,
_45_136_108_0,
Dm_Auto_Eood,
RN_Data_SIA,
ABC_Consultancy,
CT_HangZhou_IDC,
TimeWeb_Ltd_,
_185_175_93_0,
Veles_LLC,
Zomro_B_V_,
OVH_SAS )
FROM LOCAL 'surged_entities_final.txt'
DELIMITER E'\t'
NULL '-'
SKIP 1
REJECTED DATA 'rejected_surged.out'
EXCEPTIONS 'warnings_surged.out' 
DIRECT;