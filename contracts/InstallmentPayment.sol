// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract InstallmentPayment{
    address public payer;
    address public payee;
    uint public paidInstallments;
    uint public SplitAmount;
    uint public TotalAmount;
    uint public numInstallments;
 

    enum PaymentStatus { Paid, Pending }

    receive() external payable {}

    struct Installment {
        uint DueDate;
        PaymentStatus status;
    }

    Installment[] public installments;

    constructor(
        uint _totalAmount,
        uint _numInstallments,
        address _payee,
        uint _Duration
        //note: to fill the duration days for payment when deploying, it has to convert days into seconds
        // because it's how evm executed; ex. 15 days = 15*24*60*60
    ) {
            payer = payable(msg.sender);
            payee = _payee;
            // wallet address for merchant
            TotalAmount = _totalAmount;
            numInstallments = _numInstallments;
            SplitAmount = TotalAmount/numInstallments;

        
             for (uint i = 0; i<_numInstallments ; i++) {
                installments.push(Installment({
                DueDate: block.timestamp + (i+1) * _Duration,
                // DueDate for each installment (i+1 number of current installments and so on) 
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
        payable(payer).transfer(SplitAmount);
        installment.status = PaymentStatus.Paid;
        paidInstallments++;
    }

    function getInstallmentDetails(uint index) external view returns (uint DueDate, PaymentStatus status) {
        require(index < numInstallments, "Invalid index");
        Installment memory installment = installments[index];
        return (installment.DueDate, installment.status);
    }

}
    // receive() payable external {} 

       


