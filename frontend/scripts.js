async function initContract(){
  web3 = new Web3(Web3.givenProvider);
  abi = [
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
]
  address = '0x100E7Bb2f0B70388FA7E161f337b613E5885083b'
  game_contract = new web3.eth.Contract(abi,address);
}

async function update_table(){
  var table = document.getElementById("latest_results");
  var height = table.style.height;
  var row = table.insertRow(height+1);
  var ignorer_cell = row.insertCell(0);
  //ignorer_cell.innerHTML = await posts_contract.methods.latest_post().call();
  ignorer_cell.innerHTML = 1
  var reporter_cell = row.insertCell(1);
  ignorer_cell.innerHTML = 2
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
  await game_contract.methods.act(action).send({"from":user_addresses[0],"value":1000});
}
