<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema">

	<xsl:output method="text" version="1.0" encoding="UTF-8" indent="no"/>
	
	<xsl:template name="Atributo">
		<xsl:param name="valor"/>|<xsl:call-template name="ManejaEspacios">
			<xsl:with-param name="s" select="$valor"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Normalizador de espacios en blanco -->
	<xsl:template name="ManejaEspacios">
		<xsl:param name="s"/>
		<xsl:value-of select="normalize-space(string($s))"/>
	</xsl:template>

	<xsl:template match="/">|<xsl:apply-templates select="/FichaDatos"/>||</xsl:template>
	
	<xsl:template match="FichaDatos">
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@version"/>
		</xsl:call-template>
		
		<xsl:apply-templates select="./Titulo"/>
		<xsl:apply-templates select="./Persona"/>
		<xsl:apply-templates select="./Contacto"/>
	</xsl:template>


	<xsl:template match="Titulo">
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@fechaExpedicion"/>
		</xsl:call-template>
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@creadoPor"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="Persona">
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@nombre"/>
		</xsl:call-template>
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@apellidos"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="Contacto">
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@correoElectronico"/>
		</xsl:call-template>
		<xsl:call-template name="Atributo">
			<xsl:with-param name="valor" select="./@curp"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>