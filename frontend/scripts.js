async function initContract(){
  web3 = new Web3(Web3.givenProvider);
  abi =[
	{
		"constant": false,
		"inputs": [
			{
				"name": "_reported",
				"type": "uint8"
			}
		],
		"name": "act",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_ignorers",
				"type": "uint256"
			},
			{
				"indexed": false,
				"name": "_reporters",
				"type": "uint256"
			}
		],
		"name": "Results",
		"type": "event"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "withdraw",
		"outputs": [
			{
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "check_balance",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "contract_balance",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];
  address = '0x7a179d398dDf7C7E7CC95Ab17A427D707d79002d';
  game_contract = new web3.eth.Contract(abi,address);
  var table2 = document.getElementById('balance_table');
  var height = table2.style.height;
  var row2 = table2.insertRow(height+1);
  var balance = row2.insertCell();
  //balance.innerHTML = await game_contract.methods.check_balance().call();

  const user_addresses = await web3.eth.getAccounts();
  main_address=user_addresses[0];
  balance.innerHTML = await (game_contract.methods.check_balance().call({"from":user_addresses[0],}))/1000000000000;
  var table = document.getElementById("latest_results");

  // var resp = await game_contract.getPastEvents();
  // console.log(resp);
  game_contract.getPastEvents('Results', {
    fromBlock: 0,
    toBlock: 'latest'
  }, (error, events) => {
    for (i=0; i<2; i++) {
      var height = table.style.height;
      var row = table.insertRow(height+1);
      var reporter_cell = row.insertCell(0);
      reporter_cell.innerHTML =events[i]['returnValues']['_ignorers'];
      var ignorer_cell = row.insertCell(1);
      ignorer_cell.innerHTML = events[i]['returnValues']['_reporters'];
      }
    }
      )
  .then((events) => {
  });
}


async function submit_action(){
  var action;
  if (document.getElementById('ignore').checked) {
  action = document.getElementById('ignore').value;
  }
  if (document.getElementById('report').checked) {
  action = document.getElementById('report').value;
  }
  const user_addresses = await web3.eth.getAccounts();
  main_address=user_addresses[0];
  await game_contract.methods.act(action).send({"from":user_addresses[0],"value":1000000000000000});
}


async function withdraw_funds(){
  var action;
  const user_addresses = await web3.eth.getAccounts();
  main_address=user_addresses[0];
  await game_contract.methods.withdraw.call({"from":user_addresses[0]});
}
