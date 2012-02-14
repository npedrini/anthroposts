package net.looklisten.notes.soap
{
	 import mx.rpc.xml.Schema
	 public class BaseNotesSchema
	{
		 public var schemas:Array = new Array();
		 public var targetNamespaces:Array = new Array();
		 public function BaseNotesSchema():void
{		
			 var xsdXML0:XML = <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://schemas.xmlsoap.org/wsdl/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns0="http://looklisten.net/notes/service.php?wsdl" xmlns:ns1="http://looklisten.net/notes/service.php?wsdl" xmlns:ns10="http://looklisten.net/notes/service.php?wsdl" xmlns:ns11="http://looklisten.net/notes/service.php?wsdl" xmlns:ns2="http://looklisten.net/notes/service.php?wsdl" xmlns:ns3="http://looklisten.net/notes/service.php?wsdl" xmlns:ns8="http://looklisten.net/notes/service.php?wsdl" xmlns:ns9="http://looklisten.net/notes/service.php?wsdl" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:tns="http://looklisten.net/notes/service.php?wsdl" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" attributeFormDefault="unqualified" elementFormDefault="unqualified" targetNamespace="http://looklisten.net/notes/service.php?wsdl">
    <xsd:import namespace="http://schemas.xmlsoap.org/soap/encoding/"/>
    <xsd:import namespace="http://schemas.xmlsoap.org/wsdl/"/>
    <xsd:complexType name="Note">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="category_id" type="xsd:int"/>
            <xsd:element name="type_id" type="xsd:int"/>
            <xsd:element name="location_id" type="xsd:int"/>
            <xsd:element name="content" type="xsd:string"/>
            <xsd:element name="content_addtl" type="xsd:string"/>
            <xsd:element name="language" type="xsd:string"/>
            <xsd:element name="found_date" type="xsd:string"/>
            <xsd:element name="found_street" type="xsd:string"/>
            <xsd:element name="found_street_2" type="xsd:string"/>
            <xsd:element name="found_street_no" type="xsd:string"/>
            <xsd:element name="image_width" type="xsd:int"/>
            <xsd:element name="image_height" type="xsd:int"/>
            <xsd:element name="is_favorite" type="xsd:int"/>
            <xsd:element name="rotation_offset" type="xsd:int"/>
            <xsd:element name="created_date" type="xsd:string"/>
            <xsd:element name="modified_date" type="xsd:string"/>
            <xsd:element name="color_hex" type="xsd:int"/>
            <xsd:element name="has_audio" type="xsd:int"/>
            <xsd:element name="complexity" type="xsd:int"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="Category">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="title" type="xsd:string"/>
            <xsd:element name="parent_id" type="xsd:int"/>
            <xsd:element name="delimit" type="xsd:int"/>
            <xsd:element name="num_children" type="xsd:int"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="Type">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="title" type="xsd:string"/>
            <xsd:element name="width_inches" type="xsd:string"/>
            <xsd:element name="height_inches" type="xsd:string"/>
            <xsd:element name="parent_id" type="xsd:int"/>
            <xsd:element name="num_children" type="xsd:int"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="Location">
        <xsd:all>
            <xsd:element name="id" type="xsd:int"/>
            <xsd:element name="city" type="xsd:string"/>
            <xsd:element name="state" type="xsd:string"/>
            <xsd:element name="country" type="xsd:string"/>
        </xsd:all>
    </xsd:complexType>
    <xsd:complexType name="NoteArray">
        <xsd:complexContent>
            <xsd:restriction base="SOAP-ENC:Array">
                <xsd:attribute ref="SOAP-ENC:arrayType" wsdl:arrayType="tns:Note[]"/>
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
    <xsd:complexType name="TypeArray">
        <xsd:complexContent>
            <xsd:restriction base="SOAP-ENC:Array">
                <xsd:attribute ref="SOAP-ENC:arrayType" wsdl:arrayType="tns:Type[]"/>
            </xsd:restriction>
        </xsd:complexContent>
    </xsd:complexType>
    <xsd:complexType name="LocationArray">
        <xsd:complexContent>
            <xsd:restriction base="SOAP-ENC:Array">
                <xsd:attribute ref="SOAP-ENC:arrayType" wsdl:arrayType="tns:Location[]"/>
            </xsd:restriction>
        </xsd:complexContent>
    </xsd:complexType>
    <xsd:element name="getCategories">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getTypes">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getLocations">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getNotes">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="limit" type="xsd:int"/>
                <xsd:element form="unqualified" name="type_id" type="xsd:int"/>
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
    <xsd:element name="getTypesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:TypeArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getLocationsResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:LocationArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getNotesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:NoteArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getCategories">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getTypes">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getLocations">
        <xsd:complexType>
            <xsd:sequence/>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getNotes">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="limit" type="xsd:int"/>
                <xsd:element form="unqualified" name="type_id" type="xsd:int"/>
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
    <xsd:element name="getTypesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:TypeArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getLocationsResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:LocationArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
    <xsd:element name="getNotesResponse">
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element form="unqualified" name="return" type="ns10:NoteArray"/>
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>
;
			 var xsdSchema0:Schema = new Schema(xsdXML0);
			schemas.push(xsdSchema0);
			targetNamespaces.push(new Namespace('','http://looklisten.net/notes/service.php?wsdl'));
		}
	}
}