<?xml version="1.0" encoding="UTF-8"?>

<Configuration>
  <Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
  <Version>2.0</Version>
  <MachineName>millturn_3_axis</MachineName>
  <Sourcing>
    <Sequence>
		<Layer Name="Base Libraries" ReadOnly="true" SubFolder="Libraries">
			<Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
			<Template>${UGII_CAM_RESOURCE_DIR}post_configurator/post_template/libraries/libraries.psl</Template>
			<Version>1.00</Version>
			<Order>1001</Order>
			<Scripts>
				<Filename Name="lib_sourcing" Processing="auto"/>
				<Filename Name="lib_general" Processing="auto"/>
				<Filename Name="lib_xml_handling" Processing="auto"/>
				<Filename Include="pretreatment" Name="lib_pretreatment" Processing="auto"/>
				<Filename Include="pretreatment" Name="lib_pretreatment_post" Processing="auto"/>
				<Filename Name="lib_msg" Processing="true"/>
				<Filename Name="lib_file_handling" Processing="true"/>
				<Filename Name="lib_standard_post_func" Processing="true"/>
				<Filename Name="lib_document" Processing="true"/>
			</Scripts>
			<DefinedEvents>
				<Filename Include="pretreatment" Name="lib_pretreatment" Processing="auto"/>
			</DefinedEvents>
			<CustomerDialogs>
			</CustomerDialogs>
			<Functions>
			</Functions>
			<Comments>
			  <Comment>
				  <User>Siemens Product Lifecycle Management Software Inc.</User>
				  <Date>01.01.2019 12:00:00</Date>
				  <Text>Initial generated by Post Configurator</Text>
			  </Comment>
			</Comments>
		</Layer>
    	<Layer Name="Controller Libraries" ReadOnly="true" SubFolder="Controller">
			<Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
			<Template>${UGII_CAM_RESOURCE_DIR}post_configurator/post_template/controller/template/base/ctrl_template_base.psl</Template>
			<Version>1.00</Version>
			<Order>2001</Order>
			<Scripts>
				<Filename Name="ctrl_template_base" Processing="true"/>
				<Filename Name="ctrl_template_base_msg" Processing="true"/>
			</Scripts>
			<DefinedEvents>
				<Filename Include="true" Name="ctrl_template_base" Processing="auto"/>
			</DefinedEvents>
			<CustomerDialogs>
				<Filename Include="true" Name="ctrl_template_base" Processing="auto"/>
			</CustomerDialogs>
			<Functions>
			</Functions>
			<Comments>
			  <Comment>
				  <User>Siemens Product Lifecycle Management Software Inc.</User>
				  <Date>01.01.2019 12:00:00</Date>
				  <Text>Initial generated by Post Configurator</Text>
			  </Comment>
			</Comments>
		</Layer>
		<Layer Name="Machine Tool Builder Library" ReadOnly="false">
			<Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
			<Version>1.00</Version>
			<Order>3001</Order>
			<Scripts>
				<Filename Name="millturn_3_axis_mtb" Processing="true"/>
			</Scripts>
			<DefinedEvents>
			</DefinedEvents>
			<CustomerDialogs>
			</CustomerDialogs>
			<Functions>
			</Functions>
			<Comments>
			  <Comment>
				  <User>Siemens Product Lifecycle Management Software Inc.</User>
				  <Date>01.01.2019 12:00:00</Date>
				  <Text>Initial generated by Post Configurator</Text>
			  </Comment>
			</Comments>
		</Layer>
		<Layer Name="Service Libraries" ReadOnly="false">
			<Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
			<Version>1.00</Version>
			<Order>8001</Order>
			<Scripts>
				<Filename Name="millturn_3_axis_service_template" Processing="true"/>
			</Scripts>
			<DefinedEvents>
			</DefinedEvents>
			<CustomerDialogs>
			</CustomerDialogs>
			<Functions>
			</Functions>
			<Comments>
			  <Comment>
				  <User>Siemens Product Lifecycle Management Software Inc.</User>
				  <Date>01.01.2019 12:00:00</Date>
				  <Text>Initial generated by Post Configurator</Text>
			  </Comment>
			</Comments>
		</Layer>
		<Layer Name="Customer Libraries" ReadOnly="true">
			<Copyright>Siemens Product Lifecycle Management Software Inc.</Copyright>
			<Version>1.00</Version>
			<Order>9001</Order>
			<Scripts>
				<Filename Name="millturn_3_axis_custom" Processing="true"/>
			</Scripts>
			<DefinedEvents>
				<Filename Include="true" Name="millturn_3_axis_custom" Processing="true"/>
			</DefinedEvents>
			<CustomerDialogs>
				<Filename Include="true" Name="millturn_3_axis_custom" Processing="true"/>
			</CustomerDialogs>
			<Functions>
			</Functions>
			<Comments>
			  <Comment>
				  <User>Siemens Product Lifecycle Management Software Inc.</User>
				  <Date>01.01.2019 12:00:00</Date>
				  <Text>Initial generated by Post Configurator</Text>
			  </Comment>
			</Comments>
		</Layer>
	</Sequence>
  </Sourcing>
  <History>
	<Comments>
		<Comment>
		  <User>lili</User>
		  <Date>30.03.2020 12:33:34</Date>
		  <Text>Initial generated by Post Configurator</Text>
		</Comment>
		
	</Comments>
    <Customer>
      <Company/>
      <Address/>
      <Contact/>
      <Phone/>
      <Fax/>
      <Mail/>
    </Customer>
  </History>
<Units>Millimeters</Units>
</Configuration>
