async function initContract(){
  web3 = new Web3(Web3.givenProvider);
  abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_post",
				"type": "string"
			}
		],
		"name": "post",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "latest_post",
		"outputs": [
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
  address = '0xe471b5cf7042b3187a99dbf0cc33530e93c68086'
  posts_contract = new web3.eth.Contract(abi,address);
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

async function submit_post(){
  var action;
  if (document.getElementById('ignore').checked) {
  action = document.getElementById('ignore').value;
  }
  if (document.getElementById('report').checked) {
  action = document.getElementById('report').value;
  }
  console.log(action);
  // const user_addresses = await web3.eth.getAccounts();
  // main_address=user_addresses[0];
  // await posts_contract.methods.post(post).send({"from":user_addresses[0]});
}
