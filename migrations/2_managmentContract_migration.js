const ManagmentDappContract = artifacts.require("ManagmentDappContract");

module.exports = function (deployer) {
	deployer.deploy(ManagmentDappContract);
};
