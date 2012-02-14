package net.looklisten
{
	 import mx.rpc.xml.Schema
	 public class BaseWorryBoxSoapClientSchema
	{
		 public var schemas:Array = new Array();
		 public var targetNamespaces:Array = new Array();
		 public function BaseWorryBoxSoapClientSchema():void
{		
			 var xsdXML0:XML = <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns10="http://worrybox.looklisten.net/service.php?wsdl" xmlns:ns11="http://worrybox.looklisten.net/service.php?wsdl" xmlns:ns6="http://worrybox.looklisten.net/service.php?wsdl" xmlns:ns7="http://worrybox.looklisten.net/service.php?wsdl" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:tns="http://worrybox.looklisten.net/service.php?wsdl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" attributeFormDefault="unqualified" elementFormDefault="unqualified" targetNamespace="http://worrybox.looklisten.net/service.php?wsdl">
    <xsd:import namespace="http://schemas.xmlsoap.org/soap/encoding/"/>
    <xsd:import namespace="http://schemas.xmlsoap.org/wsdl/"/>
    <xsd:complexType name="Worry">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="category_id" type="xsd:int"/>
            <xsd:element name="worry_type" type="xsd:string"/>
            <xsd:element name="content" type="xsd:string"/>
            <xsd:element name="title" type="xsd:string"/>
            <xsd:element name="tags" type="xsd:string"/>
            <xsd:element name="video" type="xsd:string"/>
            <xsd:element name="submission_date" type="xsd:string"/>
            <xsd:element name="created_date" type="xsd:string"/>
            <xsd:element name="modified_date" type="xsd:string"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="Category">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="title" type="xsd:string"/>
            <xsd:element name="num_children" type="xsd:int"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="WorryArray">
        <xsd:complexContent>
            <xsd:restriction base="SOAP-ENC:Array">
                <xsd:attribute ref="SOAP-ENC:arrayType" wsdl:arrayType="tns:Worry[]"/>
            </xsd:restriction>
        </xsd:complexContent>
    </xsd:complexType>
    <xsd:complexType name="CategoryArray">
        <xsd:complexContent>
            <xsd:restriction base="SOAP-ENC:Array">
                <xsd:attribute ref="SOAP-ENC:arrayType" wsdl:arrayType="tns:Category[]"/>
            </xsd:restriction>
        </xsd:complexContent>
    </xsd:complexType>
    <xsd:element name="getCategories">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getWorries">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="limit" type="xsd:int"/>
                <xsd:element form="unqualified" name="category_id" type="xsd:int"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getCategoriesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:CategoryArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getWorriesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:WorryArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getCategories">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getWorries">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="limit" type="xsd:int"/>
                <xsd:element form="unqualified" name="category_id" type="xsd:int"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getCategoriesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:CategoryArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getWorriesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:WorryArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>
;
			 var xsdSchema0:Schema = new Schema(xsdXML0);
			schemas.push(xsdSchema0);
			targetNamespaces.push(new Namespace('','http://worrybox.looklisten.net/service.php?wsdl'));
		}
	}
}