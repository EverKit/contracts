pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Contract {
    uint32 public unfreeze_date;

    constructor(uint32 date) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        // Необходимо, чтобы дата разморозки средств была моментом в будущем
        require(date > now, 103, "Date should be a moment in future");
        
        tvm.accept();

        // Фиксируем дату разморозки средств в данных контракта
        unfreeze_date = date;
    }

    function sendValue(address dest, uint128 amount, bool bounce) public view {
        require(msg.pubkey() == tvm.pubkey(), 102);
        // Добавим наше условие, чтобы выдавать ошибку всякий раз, 
        // когда владелец контракта попытается вывести средства до указанной даты
        require(unfreeze_date < now, 104, "It's too early");

        tvm.accept();
        
        dest.transfer(amount, bounce, 0);
    }
}
