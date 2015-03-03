/**
 * This configuration file will store all teh host and port details for downstream services and databases connected from this service.
 *
 * Created by Prabhash Rathore on 12/1/14.
 */

var hostConfig = {

    //Database where Provisional Account data is stored
    provAccountDBHost : '127.0.0.1',
    provAccountDBPort : '27017',

    //Host where all DownStream services are running
    adminServiceHost : 'api.sandbox.paypal.com',
    adminServicePort : '443'

};

module.exports = hostConfig;
