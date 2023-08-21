// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract InstallmentPayment{
    address public payer;
    address public payee;
    uint public PaidAmount;
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

    Installment[] public Installments;

    constructor(
        // uint _TotalAmount,
        uint _numInstallments,
        // address _payee,
        uint _Duration
        //note: to fill the duration days for payment, it has to convert days into seconds
        // because it's how evm executed; ex. 15 days = 15*24*60*60
    ) {
        payer = payable(msg.sender);
        numInstallments = _numInstallments;

        
        for (uint i = 0; i<_numInstallments ; i++) {
            Installments.push(Installment({
                DueDate: block.timestamp + (i+1) * _Duration,
                status: PaymentStatus.Pending
            }));
        }
        

    }

}
    // receive() payable external {} 

       


