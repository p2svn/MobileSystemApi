﻿var _w88_wallets = w88Mobile.Wallets = Wallets();

function Wallets() {
    return {
        init: init,
    }

    // NOTE: isSelectOrder = true = use wallet-balance template and selection name
    // NOTE: isSelectOrder = false = use wallet-group template and lang name
    // NOTE: isSelectOrder = undefined = main wallet only
    function init(isSelectOrder, selector) {
        if (_.isUndefined(isSelectOrder)) {
            getMainWallet();
        }
        else {
            getWallets(isSelectOrder, selector);
        }
    }

    function getMainWallet() {
        var resource = "/user/wallet/0";
        send(resource, "GET", { selector: "wallets" }, function (response) {
            if (_.isUndefined(response.ResponseData)) {
                console.log('Unable to fetch wallet.');
                return;
            }
            pubsub.publish("wallets", response.ResponseData);

            setMainWalletTpl(response.ResponseData);
        });
    }


    function setMainWalletTpl(wallet) {
        var main = _.template(_w88_templates.MainWallet);
        var mainwallet = main(wallet);

        $(".wallets").append(mainwallet);
    }

    function onWalletsLoaded(topic, data) {
        var main = _.template(_w88_templates.MainWallet);
        var mainwallet = main(wallet);

        $(".wallets").append(mainwallet);
    }

    function getWallets(isSelectOrder, selector) {

        var selector = _.isUndefined(selector) ? "" : selector;

        var resource = "/user/wallets?isSelectOrder=" + isSelectOrder;
        send(resource, "GET", selector, function (response) {
            if (_.isUndefined(response.ResponseData)) {
                console.log('Unable to fetch wallets.');
                return;
            }

            wallets = response.ResponseData;
            pubsub.publish("wallets", wallets);

            setMainWalletTpl(_.first(wallets));

            if (_.isEqual(isSelectOrder, true)) {
                var balance = _.template(_w88_templates.WalletBallance);
                var walletbalance = balance({ wallets: wallets });

                $(".wallet-balance").append(walletbalance);
            } else {

                var wallets = _.filter(wallets, function (data) {
                    return !_.isEqual(data.Id, 0);
                });

                var group = _.template(_w88_templates.WalletGroup);
                var walletgroup = group({ wallets: wallets });

                $(".wallets").append(walletgroup);
            }
        });
    }
}