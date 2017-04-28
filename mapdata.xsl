<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template match="/">
<html>
  <head>
    <style type="text/css">
        table { width : 100%; table-layout: fixed; }
    </style>
  </head> 
  <body>
    <h2>Food Finder Map Data (raw)</h2>  
    <table border="2">
      <tr bgcolor="#9acd32">
        <th align="left" width="20%">Name</th> 
        <th align="left" width="45%">Info</th> 
        <th align="center" width="5%">Savour Ottawa</th> 
        <th align="left" width="10%">Org Type</th>  
        <th align="left" width="20%">Additional Info</th> 
      </tr>
      <xsl:for-each select="markers/marker"> 
                <xsl:sort select="savour" order="descending"/>   
                <xsl:sort select="name"  />  
            
      <tr>
        <td><h3><xsl:value-of select="name" /></h3></td>
        <td><xsl:value-of select="infowindow" disable-output-escaping="yes"/>
        <p>  
        <xsl:variable name="nbid" select="nbid" /> 
        <b>NBID: </b>  <xsl:value-of select="$nbid"/>  
        </p> 
        <p>  
        <xsl:variable name="website" select="website" /> 
        <b>Website(tag): </b>  <xsl:value-of select="$website"/>  
        </p> 
        <p>  
        <xsl:variable name="email" select="email" /> 
        <b>Email(tag): </b>  <xsl:value-of select="$email"/>  
        </p> 
        
        
        </td>
           
           
        <xsl:variable name="isSavour" select="savour" />
        <xsl:if test="$isSavour = 'true'">
            <td align="center" bgcolor="green">  Y </td>
          </xsl:if>
          <xsl:if test="$isSavour != 'true'">
          <td align="center" bgcolor="red">  N </td>
        </xsl:if>
          
        
        <xsl:variable name="farmtypes" select="farmtypes" />
        <xsl:variable name="favorites" select="favorites" />
        <xsl:variable name="productiontypes" select="productiontypes" />
        
        <td><xsl:value-of select="orgtype" /></td> 
        
        <td> 
          <xsl:if test="$farmtypes != ''">
            <p><b>Farm Type: </b> 
              
              <xsl:value-of select="$farmtypes" />
              <xsl:variable name="hasValue" select="1" />
              </p> 
          </xsl:if> 
          
<xsl:variable name="fv">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$favorites" />
      <xsl:with-param name="replace" select="'fm-'" />
      <xsl:with-param name="by" select="' '" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fv1">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$fv" />
      <xsl:with-param name="replace" select="'fv-'" />
      <xsl:with-param name="by" select="' '" />
    </xsl:call-template>
  </xsl:variable>
   <xsl:variable name="fv2">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$fv1" />
      <xsl:with-param name="replace" select="'ff-'" />
      <xsl:with-param name="by" select="' '" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="fv3">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$fv2" />
      <xsl:with-param name="replace" select="'fs-'" />
      <xsl:with-param name="by" select="' '" />
    </xsl:call-template>
  </xsl:variable>
  
   <xsl:variable name="fv4">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="$fv3" />
      <xsl:with-param name="replace" select="'fa-'" />
      <xsl:with-param name="by" select="' '" />
    </xsl:call-template>
  </xsl:variable>
  
              
          <xsl:if test="$favorites != ''">
              <p><b>Favorites: </b> 
              <xsl:value-of select="$fv4" />
            </p>
              <xsl:variable name="hasValue" select="1" />
          </xsl:if> 
          <xsl:if test="$productiontypes != ''">
              <p><b>Growing Style: </b>
              <xsl:value-of select="$productiontypes" />
              </p>
              <xsl:variable name="hasValue" select="1" />
          </xsl:if>  
              
           <p>  </p> 
          
         </td>  
      </tr>
      </xsl:for-each>
    </table> 
  </body>
  </html>
</xsl:template> 
</xsl:stylesheet>   