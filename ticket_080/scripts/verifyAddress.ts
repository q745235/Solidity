import verify from '../utils/verify';

verify({
    address: "",
    contract: "contracts/Ticket.sol:Ticket",
    constructorArguments: [
        "Ticket",
        "q745235",
        "https://q745235/ticket/"
    ],
}).then(console.log)

