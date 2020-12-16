```
//治理点信息
TcGvnSubServiceType tcGvnSubServiceType = new TcGvnSubServiceType();
tcGvnSubServiceType.setSubServiceId(tbUcCfgEtlTask.getSubServiceId());
Res<TcGvnSubServiceType> dataGovernSubService = dataGovernServerApi.getByIdSubServiceType(tcGvnSubServiceType);
```

