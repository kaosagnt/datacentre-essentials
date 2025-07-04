# UNP - User Principal Name

UPN suffixes: Users can log on with the UPN associated with their accounts. A UPN takes the form user@upnsuffix, such as username@example.com.

The UPN suffix generally identifies the domain in which the account resides, but it can be the domain DNS name, the DNS name of another domain in the forest, or an alternative suffix created by the domain administrator solely for the purpose of logon.


UNP suffix: dca.com.au

Active Directory, you can add additional (alternative) UPN suffixes using the Active Directory Domains and Trusts graphic console or PowerShell.

Open a PowerShell console:

	Get-ADForest | Format-List UPNSuffixes

If the list is empty, it means that you are using a default UPN suffix matching your DNS domain name.

To add an alternative UPN suffix:

	Get-ADForest | Set-ADForest -UPNSuffixes @{add="dca.com.au"}


## Reference list

Lowe, S 2009, *An overview of the Active Directory Domains And Trusts Console*, TechRepublic, <<https://www.techrepublic.com/article/an-overview-of-the-active-directory-domains-and-trusts-console/>>.

*Windows OS Hub* 2021, Windows OS Hub, viewed 13 June 2025, <<https://woshub.com/configure-userprincipalname-upn-suffixes-active-directory/>>.