<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0" exclude-result-prefixes="xsl xs">
<xsl:import href="common.xslt"/>
<xsl:output method="html" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

<!-- ignored elements -->
	
	<xsl:template match="p|h1|h2|h3|h4">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="div[contains(@class, 'columns')]">
		<xsl:for-each select="*">
			<div class="columns-item">
				<xsl:apply-templates select="."/>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="div[not(contains(@class, 'columns'))]|table|inline|ol|li|tr|td|br ">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:value-of select="text()"/>
			<xsl:apply-templates select="*" />
		</xsl:copy>
	</xsl:template>

    <!-- Auction -->

    <!-- NS Auction -->
	
	<xsl:template match="auction[@onesided]">
		<div>
			<xsl:attribute name="data-dealer"> 
				<xsl:value-of select='@dealer'/>
			</xsl:attribute>
			<xsl:attribute name="class">
				auction auction-onesided
				<xsl:if test="@revealable"> revealable</xsl:if>
			</xsl:attribute>
			
			<xsl:variable name="m">
				<xsl:choose>
					<xsl:when test="@dealer = 'S'">
						0
					</xsl:when>
					<xsl:when test="@dealer = 'N'">
						1
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<table>
				<thead>
					<tr>
						<th>N</th>
						<th>S</th>
					</tr>
				</thead>
				<tbody>
					<xsl:if test="@dealer = 'S'">
						<tr>
							<td class="bid-placeholder"></td>
							<td>
							<xsl:apply-templates select="bid[1]"/>
							</td>
						</tr>
					</xsl:if>
					<xsl:for-each select="bid[position() mod 2 = $m]">
					
						<tr>
							<td>
								<xsl:apply-templates   select="."/>
							</td>
							<td>
								<xsl:apply-templates select="following-sibling::bid[1]"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
				
			</table>		
		</div>
	</xsl:template>
	
	<xsl:template match="auction[not(@onesided) or @onesided = 'false']">
		<div class="auction auction-nsew">
			<xsl:attribute name="data-dealer"> 
				<xsl:value-of select='@dealer'/>
			</xsl:attribute>
			
			<xsl:variable name="m">
				<xsl:choose>
					<xsl:when test="@dealer = 'W'">
						0
					</xsl:when>
					<xsl:when test="@dealer = 'N'">
						1
					</xsl:when>
					<xsl:when test="@dealer = 'E'">
						2
					</xsl:when>
					<xsl:when test="@dealer = 'S'">
						3
					</xsl:when>
				</xsl:choose>
			</xsl:variable>

			<table>
				<thead>
					<tr>
						<th>W</th>
						<th>N</th>
						<th>E</th>
						<th>S</th>
					</tr>
				</thead>
				<tbody>
					<xsl:if test="not(@dealer = 'W')">
						<tr>
						<xsl:choose>
						<xsl:when test="@dealer = 'N'"><td class="bid-placeholder"></td></xsl:when>
						<xsl:when test="@dealer = 'E'"><td class="bid-placeholder"></td><td class="bid-placeholder"></td></xsl:when>
						<xsl:when test="@dealer = 'S'"><td class="bid-placeholder"></td><td class="bid-placeholder"></td><td class="bid-placeholder"></td></xsl:when>
						</xsl:choose>
						<xsl:for-each select="bid[position() &lt;= $m]">
							<td>
								<xsl:apply-templates select="."/>
							</td>
						</xsl:for-each>
						</tr>
					</xsl:if>
					<xsl:for-each select="bid[position() mod 4 = $m]">
					
						<tr>
							<td>
								<xsl:apply-templates select="."/>
							</td>
							<td>
								<xsl:apply-templates select="following-sibling::bid[1]"/>
							</td>
							<td>
								<xsl:apply-templates select="following-sibling::bid[2]"/>
							</td>
							<td>
								<xsl:apply-templates select="following-sibling::bid[3]"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>
	</xsl:template>

</xsl:stylesheet>