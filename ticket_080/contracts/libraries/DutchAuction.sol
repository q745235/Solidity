// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

library DutchAuction{

    struct Data{
        Config1 config1;
        Config2 config2;
        ConfigType configType;
    }

    enum ConfigType{
        isNull,
        config1,
        config2
    }

    struct Config1{
        uint interval; //How often to change the prices
        uint startTime;
        uint startPrice;
        uint endTime;
        uint endPrice;
    }

    struct Config2{
        uint interval; //How often to change the prices
        uint startTime;
        uint startPrice;
        uint decrease; //decrease per sec (Price*10**18/sec)
    }

    function set(
        DutchAuction.Data storage data,
        uint interval,
        uint startTime,
        uint startPrice,
        uint endTime,
        uint endPrice
    ) internal {
        require(
            data.configType == ConfigType.isNull,
            "DutchAuction: the config has been set"
        );
        require(
            interval != 0,
            "DutchAuction: the interval must be not 0"
        );
        require(
            endTime > startTime,
            "DutchAuction: the endTime must be over than startTime"
        );
        require(
            startPrice > endPrice,
            "DutchAuction: the startPrice must be over than endPrice"
        );
        data.config1 = DutchAuction.Config1({
            interval: interval,
            startTime: startTime,
            startPrice: startPrice,
            endTime: endTime,
            endPrice: endPrice
        });
        data.configType = ConfigType.config1;
    }

    function set(
        DutchAuction.Data storage data,
        uint interval,
        uint startTime,
        uint startPrice,
        uint decrease
    ) internal {
        require(
            data.configType == ConfigType.isNull,
            "DutchAuction: the config has been set"
        );
        require(
            interval != 0,
            "DutchAuction: the interval must be not 0"
        );
        data.config2 = DutchAuction.Config2({
            interval: interval,
            startTime: startTime,
            startPrice: startPrice,
            decrease: decrease
        });
        data.configType = ConfigType.config2;
    }

    function _getPriceByType1(
        DutchAuction.Config1 storage config
    ) private view returns(uint price){
        if(config.startTime > block.timestamp){
            return config.startPrice;
        }else if(block.timestamp > config.endTime){
            return config.endPrice;
        }
        
        uint timeRange = config.endTime - config.startTime;
        uint priceRange = config.startPrice - config.endPrice;
        uint passTime = (block.timestamp - config.startTime);
        uint decrease = priceRange/timeRange;
        uint priceStageRange = (decrease * config.interval)/(10**18);
        uint stage = passTime*(10**18) / config.interval;

        if(config.startPrice > stage * priceStageRange){
            return config.startPrice - stage * priceStageRange;
        }else{
            return 0;
        }
    }

    function _getPriceByType2(
        DutchAuction.Config2 storage config
    ) private view returns(uint price){
        if(config.startTime > block.timestamp){
            return config.startPrice;
        }
        
        uint passTime = block.timestamp - config.startTime;
        uint stage = passTime * (10**18) / config.interval;
        uint priceStageRange = (config.decrease * config.interval)/(10**18);

        if(config.startPrice > stage * priceStageRange){
            return config.startPrice - stage * priceStageRange;
        }else{
            return 0;
        } 
    }

    function getPrice(
        DutchAuction.Data storage data
    ) internal view returns(uint price){
        if(data.configType == ConfigType.config1){
            return _getPriceByType1(data.config1);
        }else if(data.configType == ConfigType.config2){
            return _getPriceByType2(data.config2);
        }else{
            revert("DutchAuction: the config must be set");
        }
    }

}