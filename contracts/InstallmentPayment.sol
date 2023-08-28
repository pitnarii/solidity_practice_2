// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract InstallmentPayment{
    address public payer;
    address public payee;
    uint public paidInstallments;
    uint public SplitAmount;
    // uint public Installments;
    uint public TotalAmount;
    uint public numInstallments;
    // uint public PlanLength;

    enum PaymentStatus { Paid, Pending }

    struct Installment {
        uint DueDate;
        PaymentStatus status;
    }

    Installment[] public installments;

    constructor(
        // uint _TotalAmount,
        uint _numInstallments,
        // address _payee,
        uint _Duration
        //note: to fill the duration days for payment when deploying, it has to convert days into seconds
        // because it's how evm executed; ex. 15 days = 15*24*60*60
    ) {
            payer = payable(msg.sender);
            payee = payable (msg.sender);
            numInstallments = _numInstallments;

        
             for (uint i = 0; i<_numInstallments ; i++) {
                installments.push(Installment({
                DueDate: block.timestamp + (i+1) * _Duration,
                status: PaymentStatus.Pending
            }));}
        }
    

    modifier onlyPayer() {
        require(msg.sender == payer, "Only payer can call this function.");
        _;
    }
    modifier  onlyPayee() {
        require(msg.sender == payee, "Only payee can call this function.");
        _;
    }

    function makePayment() external payable onlyPayer {
        require(paidInstallments < numInstallments);
        uint currentPayment = paidInstallments;
        Installment storage installment = installments[currentPayment];
        require(installment.status == PaymentStatus.Pending, "Installment already paid");
        require(msg.value == SplitAmount, "Incorrect payment amount");

    }

}
    // receive() payable external {} 

       


