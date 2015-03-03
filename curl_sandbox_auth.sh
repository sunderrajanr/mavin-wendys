#!/bin/bash

# Run 'npm install -g json ' to get json formatter/parser

# these are the credentials I borrowed from PaypalPlusShop demo
# app here: 
# http://paypalplussampleshop-2-8328.lvs01.dev.ebayc3.com/develop/?action=config
#
# Have CRUD_ONBOARDING_SESSION scope 
#
#CLIENT_ID=AZykehDdHgGMqGr1ahakjQIevv1MIDkNmkyMxCGaLxHPhsr3KKenp-6PJirs
#SECRET=EI1yHxBf0KFSRiVWeSlN0NrEJAkDyA5OPsaxZAIwcMgzmZ7grP6TbS08jpOW

# these are the credentials for the default that is on dev-tools.paypal.com REST API 
# interactive tool
#
# don't have CRUD_ONBOARDING_SESSION scope 
#
#CLIENT_ID=AQkquBDf1zctJOWGKWUEtKXm6qVhueUEMvXO_-MCI4DQQ4-LWvkDLIN2fGsd
#SECRET=EL1tVxAjhT7cJimnz5-Nsx9k2reTKSVfErNQF-CmrwJgxRtylkGTKlU4RvrX

# these are the credentials for 
#
#     uri:               api.sandbox.paypal.com 
#     app:               provisionalaccountserv 
#     developer account: gcross@paypal.com  
#     password:          Partner@1
#     test account:      gcross-facilitator@paypal.com
#     
# Have CRUD_ONBOARDING_SESSION scope 
#
CLIENT_ID=AVHBKRBeCwEWnvYb7GRzR7EibKoWZ7PkBko_BDoTycwXlmv1sb1aN2_Saucb
SECRET=EFxaDRB_pBnkhRS9JoOsVAEitKksa2PF6mkXHcS94EFbC16hAZGxAO8_VWrd

# these are some other credentials for my stage2p1401 account
CLIENT_ID=PAS_client
SECRET=PAS_client

# these are credentials for gcross-pas10@paypal.com on stage2ms058
CLIENT_ID=Provisional_Account_Serv3
SECRET=Partner1

# these are the credentials from the Identity team
# that work on any stage2
#CLIENT_ID=mis
#SECRET=mis

printf "%s:%s\r\n" $CLIENT_ID $SECRET

ENDPOINT="https://api.stage2p1401.qa.paypal.com:11888"
ENDPOINT="https://api.sandbox.paypal.com"
ENDPOINT="https://api.stage2ms058.qa.paypal.com:11888"
ARIES_URL="https://sandbox.paypal.com/checkoutnow/2?token="
OPTIONS="-1 -k -v "

# -u option to curl, lets you specify username:password for Basic HTTP authentication.  
# curl will then base64 encode it. 
# Alternatively you could base64 encode the username:password like below, and pass
# -H "Authorization: Basic $ENCODED_CLIENT_SECRET
ENCODED_CLIENT_SECRET=$(base64 --wrap=0 <(echo -n "$CLIENT_ID:$SECRET"))
echo $ENCODED_CLIENT_SECRET

TOKEN=`curl $OPTIONS $ENDPOINT/v1/oauth2/token \
	-H "Accept: application/json" \
	-u "$CLIENT_ID:$SECRET" \
	-d "grant_type=client_credentials"  \
	| json access_token`

printf "TOKEN: %s\n" $TOKEN
	
# consumer info
EMAILID="gcross-consumer10@paypal.com"
PASSWORD="12345_consumerpwd"
CCNUMBER="4032034813331355"

if [[ $CALL_ONBOARDING ]] ; then
	# this API caller needs a token to make calls
	# now create an account
	#
	# be sure API caller has this scope for onboarding:
	#   https://uri.paypal.com/services/customer/onboarding/application
	#
	# on stage2, you can use the scopemanagement tool eg.
	#   https://stage2ms058.qa.paypal.com/scopemanagement
	
	ACCOUNT=`curl $OPTIONS $ENDPOINT/v1/customer/onboarding/applications/ \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $TOKEN" \
		-H "Accept: application/json" \
		-H "paypal-entry-point: http://uri.paypal.com/Web/Web/Consumer/consonbdnodeweb/createAccount" \
		-H "npp_remote_addr: 127.0.0.1" \
		-H "browser_raw_data: =na~a3=na~a4=Mozilla~a5=Netscape~a6=5.0(Macintosh)~a7=20100101~a8=na~" \
		-H "fso_id: QfEdm_0flMaZ9dCx36ShlQ620yWv6ibiOYEBQnMUGZGVYHSAbxG_DPWTwTC" \
		-H "fso_blocked: false" \
		-H "flash_enabled: true" \
		-H "visitor_id: 1234567890" \
		-d '{
					"dimension": {
							"country": "US",
							"customer_type": "CONSUMER",
							"business_channel": "ANY",
							"technical_channel": "WEB",
							"partner_channel": null,
							"experience_channel": "ANY",
							"intents": ["CREATE_ACCOUNT",
							"LINK_BANK_ACCOUNT",
							"LINK_CREDIT_CARD"]
					},
					"customer_id_type": null,
					"customer_id": null,
					"status": null,
					"id": null,
					"errors": [],
					"links": [],
					"documents": [{
							"id": "",
							"name": "DocumentConsumerCreateAccountFormI",
							"dimension": {
									"country": "US",
									"customer_type": "CONSUMER",
									"business_channel": "ANY",
									"technical_channel": "WEB",
									"partner_channel": null,
									"experience_channel": "ANY",
									"capability": "CREATE_ACCOUNT"
							},
							"content": {
									"country_of_account": {
											"country": "US"
									},
									"personal_preferences": {
											"language": "en_US"
									},
									"credentials": {
											"email": "'$EMAILID'",
											"password": "'$PASSWORD'"
									},
									"personal_information_name": {
											"first": "Saravanan",
											"middle": "K",
											"last": "Shanmugam"
									},
									"personal_information_location": {
											"line1": "3000 Aurora Ter",
											"line2": "M300",
											"city": "Fremont",
											"county": "CA",
											"post_code": "94536",
											"country": "US"
									},
									"personal_information_contact": {
											"country_code": "00",
											"phone_number": "4082451112",
											"extn": "",
											"tag": "MOBILE"
									},
									"personal_information_identification": {
											"date_of_birth": "19800101",
											"country_of_citizenship": "US",
											"tax_identifier": "619634287"
									},
									"password_recovery": {
											"security_question_1": "What was the name of your first school?",
											"security_question_2": "PayPal",
											"security_answer_1": "What was the name of your first pet",
											"security_answer_2": "eBay"
									},
									"legal_consent": {
											"credit_header_consent_flag": false,
											"market_email_opt_out_flag": false,
											"legal_agreement_flag": false,
											"major_version": "3",
											"minor_version": "2",
											"agreement_type": "C"
									}
							},
							"section_meta_data": [],
							"status": null,
							"errors": [],
							"links": []
					},
					 {
						"id": "",
						"name": "DocumentConsumerAddFICardGroupI",
						"dimension": {
							"country": "US",
							"customer_type": "CONSUMER",
							"business_channel": "ANY",
							"technical_channel": "WEB",
							"partner_channel": null,
							"experience_channel": "ANY",
							"capability": "ADD_CARD"
						},
						"content": {
							"card_details": {
								"billing_address": {
									"line1": "1223 Silvertree Ave",
									"line2": "",
									"city": "San Jose",
									"county": "Santa Clara",
									"post_code": "95131",
									"country": "US"
								},
								"account_number": "'$CCNUMBER'",
								"cvv": "378",
								"expiry_month": "02",
								"expiry_year": "2016",
								"fi_issuer": "VISA"
								
							}
						},
						
						"status": null,
						"errors": [],
						"links": []
					} ]

			}' `

	echo $ACCOUNT | json -o inspect

fi

if [[ $CALL_REFRESH ]] ; then

	# next, get a Refresh Token, which we can use for PayCode API (QR code a Point-of-Sale)
	# rememberme=true means 'give me a Refresh Token'
	# redirect_uri must match that for app credentials
	#
	# eg.   http://stage2p1108.qa.paypal.com:10080/openid-connect-client/clientregistration.jsp
	#
	#    -d "response_type=token&grant_type=password&email=prathore-pas2@paypal.com&password=12345_ghostpwd&redirect_uri=http://stage2p1108.qa.paypal.com:10080/openid-connect-client/clientregistration.jsp&rememberme=true&scope=https://uri.paypal.com/services/mis/customer https://uri.paypal.com/services/pos/payments https://uri.paypal.com/services/identity/activities" `
	#
	LOGIN=`curl $OPTIONS $ENDPOINT/v1/oauth2/login \
		-H "Accept: application/json" \
		-u "$CLIENT_ID:$SECRET" \
		-d "response_type=token&grant_type=password&email=${EMAILID}&password=${PASSWORD}&redirect_uri=http://stage2p1108.qa.paypal.com:10080/openid-connect-client/clientregistration.jsp&rememberme=true&scope=openid https://api.paypal.com/v1/payments/.* https://uri.paypal.com/services/mis/customer https://uri.paypal.com/services/pos/payments https://uri.paypal.com/services/identity/activities " `

	echo "$LOGIN" | json -o inspect

	REFRESH_TOKEN=$(echo "$LOGIN" | json refresh_token)

	echo REFRESH_TOKEN: "$REFRESH_TOKEN"

	ACTIVITIES_TOKEN=`curl $OPTIONS $ENDPOINT/v1/oauth2/token \
		-H "Accept: application/json" \
		-u "$CLIENT_ID:$SECRET" \
		-d "grant_type=refresh_token&refresh_token=$REFRESH_TOKEN&response_type=token&return_authn_schemes=true&scope=https://uri.paypal.com/services/identity/activities https://api.paypal.com/v1/payments/.* openid https://uri.paypal.com/services/wallet/financial-instruments/update https://uri.paypal.com/services/wallet/financial-instruments/view " `

	echo "ACTIVITIES_TOKEN: $ACTIVITIES_TOKEN" 

fi 

if [[ $CALL_EC ]] ; then

	# example of creating a payment
	PAYMENT=`curl $OPTIONS $ENDPOINT/v1/payments/payment \
		-H "Content-Type: application/json" \
		-H "Authorization: Bearer $TOKEN" \
		-d '{
			"intent":"sale",
				"redirect_urls":{
					"return_url":"http://example.com/your_redirect_url/",
					"cancel_url":"http://example.com/your_cancel_url/"
				},
				"payer":{
					"payment_method":"paypal"
				},
				"transactions":[
				{
					"amount":{
						"total":"7.47",
						"currency":"USD"
					}
				}
			]
		}' | json`

	LINKS=`echo "$PAYMENT" | json links`

	PAYMENT_ID=`echo "$PAYMENT" | json id`

	APPROVAL_URL=`echo "$LINKS" | json -C 'this.rel == "approval_url"' | json 0 | json href`
	PAYMENT_URL=`echo "$LINKS" | json -C 'this.rel == "self"' | json 0 | json href`
	EXECUTE_URL=`echo "$LINKS" | json -C 'this.rel == "execute"' | json 0 | json href`

	printf "Payment ID: %s\n" $PAYMENT_ID
	printf "Approval URL: %s\n" $APPROVAL_URL
	printf "Payment URL: %s\n" $PAYMENT_URL
	printf "Execute URL: %s\n" $EXECUTE_URL

	ECTOKEN=`echo "$APPROVAL_URL" | awk '{ split($0, a, "="); print a[3] }'`

	echo $ECTOKEN
	echo "$ARIES_URL$ECTOKEN"

	curl -v -k -I "$ARIES_URL$ECTOKEN"


	printf "\nNow take the Approval URL above, login, and approve the payment\n"
	read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'

	# example of completing a payment
	PAYMENT_COMPLETE=`curl $OPTIONS $EXECUTE_URL \
			-H "Content-Type: application/json" \
			-H "Authorization: Bearer $TOKEN" \
			-d '{
				"payer_id": "'$PAYER_ID'"
			}' `

	echo $PAYMENT_COMPLETE | json -o inspect

fi

if [[ $CALL_HISTORY ]] ; then

	HISTORY_TOKEN=$(echo "$ACTIVITIES_TOKEN" | json access_token)

	HISTORY=`curl -G $OPTIONS $ENDPOINT/v1/customers/@me/activities/ \
		-H "Authorization: Bearer $HISTORY_TOKEN" \
		-H "Accept: application/json" \
		-d "start_time=1414584000&end_time=1414780000" `

	echo "$HISTORY" | json -o inspect

fi

#example of adding a credit card to existing account
if [[ $CALL_WALLET ]] ; then

	CCNUMBER2="4032031254053506"
	ADD_CARD=`curl $OPTIONS $ENDPOINT/v1/wallet/@me/financial-instruments/payment-cards \
		-H "Authorization: Bearer $HISTORY_TOKEN" \
		-H "Accept: application/json" \
		-H "Content-Type: application/json" \
		-d '{	
			"type":"VISA",
			"card_number": "'${CCNUMBER2}'",
			"expire_month":"11",
			"expire_year":"2015",
			"first_name":"Steve",
			"last_name":"John",
			"cvv2":"376",
			"billing_address": {
				"address": {
					"line1": "2288 Bellevue Ave",
					"line2": " ",
					"city": "Tracy",
					"state": "CA",
					"postal_code": "95355",
					"country_code": "US"
				}
			}
		}' `

	echo $ADD_CARD | json -o inspect

fi

#			"line1": "2288 Bellevue Ave",
#			"line2": " ",
#			"city": "Tracy",
#			"state": "CA",
##			"postal_code": "95376",
##			"country_code": "US"
