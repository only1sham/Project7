App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    sku: 0,
    upc: 0,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    ownerID: "0x0000000000000000000000000000000000000000",
    originFishermanID: "0x0000000000000000000000000000000000000000",
    originCoastLocation: null,
    tunaNotes: null,
    tunaState: null,
    tunaPrice: 0,
    regulatorID: "0x0000000000000000000000000000000000000000",
    auditStatus: null,
    restaurantID: "0x0000000000000000000000000000000000000000",

    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.sku = $("#sku").val();
        App.upc = $("#upc").val();
        App.ownerID = $("#ownerID").val();
        App.originFishermanID = $("#originFishermanID").val();
        App.originCoastLocation = $("#originCoastLocation").val();
        App.tunaNotes = $("#tunaNotes").val();
        App.tunaPrice = $("#tunaPrice").val();
        App.tunaState = $("#tunaState").val();
        App.regulatorID = $("#regulatorID").val();
        App.auditStatus = $("#auditStatus").val();
        App.restaurantID = $("#restaurantID").val();

        console.log(
            App.sku,
            App.upc,
            App.ownerID, 
            App.originFishermanID, 
            App.originCoastLocation, 
            App.tunaNotes, 
            App.tunaPrice, 
            App.tunaState, 
            App.regulatorID, 
            App.auditStatus, 
            App.restaurantID
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function(err, res) {
            if (err) {
                console.log('Error:',err);
                return;
            }
            console.log('getMetaskID:',res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain='../../build/contracts/ValueChain.json';
        
        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function(data) {
            console.log('data',data);
            var SupplyChainArtifact = data;
            App.contracts.ValueChain = TruffleContract(SupplyChainArtifact);
            App.contracts.ValueChain.setProvider(App.web3Provider);
            
            // App.fetchItemBufferOne();
            // App.fetchItemBufferTwo();
            // App.fetchEvents();

        });

        return App.bindEvents();
    },

    bindEvents: function() {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function(event) {
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId',processId);

        switch(processId) {
            case 1:
                return await App.Caught(event);
                break;
            case 2:
                return await App.Recorded(event);
                break;
            case 3:
                return await App.Queried(event);
                break;
            case 4:
                return await App.Audited(event);
                break;
            case 5:
                return await App.Queried(event);
                break;
           case 6:
                return await App.Bought(event);
                break;
            case 7:
                return await App.fetchItemBufferOne(event);
                break;
            case 8:
                return await App.fetchItemBufferTwo(event);
                break;
            }
    },

    catchTuna: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.ValueChain.deployed().then(function(instance) {
            return instance.catchTuna(
                App.upc, 
                App.metamaskAccountID, 
                App.originCoastLocation
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('catchTuna',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    recordTuna: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.ValueChain.deployed().then(function(instance) {
            return instance.recordTuna(App.upc, 
                App.tunaPrice,
                App.tunaNotes,
                {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('recordTuna',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    
    auditTuna: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.ValueChain.deployed().then(function(instance) {
            return instance.auditTuna(App.upc,
                App.auditStatus,
                {from: App.metamaskAccountID});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('auditTuna',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    queryTuna: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.ValueChain.deployed().then(function(instance) {
            return instance.queryTuna(App.upc);
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('queryTuna',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    buyTuna: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.ValueChain.deployed().then(function(instance) {
            const walletValue = web3.toWei(3, "ether");
            return instance.buyTuna(App.upc, 
                App.tunaPrice,
                {from: App.metamaskAccountID, value: walletValue});
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('buyTuna',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    
    fetchItemBufferOne: function () {
    ///   event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
        App.upc = $('#upc').val();
        console.log('upc',App.upc);

        App.contracts.ValueChain.deployed().then(function(instance) {
          return instance.fetchItemBufferOne(App.upc);
        }).then(function(result) {
          $("#ftc-item").text(result);
          console.log('fetchItemBufferOne', result);
        }).catch(function(err) {
          console.log(err.message);
        });
    },

    fetchItemBufferTwo: function () {
    ///    event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
                        
        App.contracts.ValueChain.deployed().then(function(instance) {
          return instance.fetchItemBufferTwo.call(App.upc);
        }).then(function(result) {
          $("#ftc-item").text(result);
          console.log('fetchItemBufferTwo', result);
        }).catch(function(err) {
          console.log(err.message);
        });
    },

    fetchEvents: function () {
        if (typeof App.contracts.ValueChain.currentProvider.sendAsync !== "function") {
            App.contracts.ValueChain.currentProvider.sendAsync = function () {
                return App.contracts.ValueChain.currentProvider.send.apply(
                App.contracts.ValueChain.currentProvider,
                    arguments
              );
            };
        }

        App.contracts.ValueChain.deployed().then(function(instance) {
        var events = instance.allEvents(function(err, log){
          if (!err)
            $("#ftc-events").append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
        });
        }).catch(function(err) {
          console.log(err.message);
        });
        
    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});
