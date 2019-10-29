package main

import (
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// SimpleChaincode simple example of Chaincode implementation
type SimpleChaincode struct {
}

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {

	fmt.Println("ex1 Init")
	_, args := stub.GetFunctionAndParameters()
	// ##################################
	var A, B string    // Entities
	var Aval, Bval int // Asset holdings
	// ##################################
	var err error

	if len(args) != 4 {
		return shim.Error("Incorrect number of arguments. Expecting 4")
	}

	// Initialize the chaincode
	A = args[0]
	Aval, err = strconv.Atoi(args[1])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	B = args[2]
	Bval, err = strconv.Atoi(args[3])
	if err != nil {
		return shim.Error("Expecting integer value for asset holding")
	}
	fmt.Printf("Aval = %d, Bval = %d\n", Aval, Bval)

	// ####################################
	// ### Initiate entity A with a value #
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	// ####################################
	// PutState: Write the state to the ledger
	// NOTE: PutState puts the specified `key` and `value` into the transaction's
	// writeset as a data-write PROPOSAL. PutState doesn't effect the ledger
	// until the transaction is validated and successfully committed.
	if err != nil {
		return shim.Error(err.Error())
	}
	// ####################################
	// ### Initiate entity B with a value #
	err = stub.PutState(B, []byte(strconv.Itoa(Bval)))
	// ####################################
	// PutState: Write the state to the ledger
	// NOTE: PutState puts the specified `key` and `value` into the transaction's
	// writeset as a data-write PROPOSAL. PutState doesn't effect the ledger
	// until the transaction is validated and successfully committed.
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex1 Invoke")

	// GetFunctionAndParameters returns the first argument as the function
	// name and the rest of the arguments as parameters in a string array.
	// Only use GetFunctionAndParameters if the client passes arguments intended
	// to be used as strings.
	function, args := stub.GetFunctionAndParameters()
	if function == "invoke" {
		// Make payment of X-units from A to B
		return t.invoke(stub, args)
	} else if function == "query" {
		// the old "Query" is now implemtned in invoke
		return t.query(stub, args)
	}

	return shim.Error("Invalid invoke function name. Expecting \"invoke\" \"delete\" \"query\"")
}

// Transaction makes payment of X-units from A to B
func (t *SimpleChaincode) invoke(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A, B string    // ##### Entities ######
	var Aval, Bval int // ##### Asset holdings #####
	var Xunits int     // ##### Transaction value #####
	var err error

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	A = args[0]
	B = args[1]

	// ##################################
	// Get the state of A from the ledger
	// ##################################
	Avalbytes, err := stub.GetState(A)
	// ##################################
	// NOTE: GetState does not read data from the writeset, which
	// has not been committed to the ledger. In other words, GetState does not
	// consider data modified by PutState that has not been committed.
	if err != nil {
		return shim.Error("Failed to get state")
	}
	if Avalbytes == nil {
		return shim.Error("Entity not found")
	}
	Aval, _ = strconv.Atoi(string(Avalbytes))
	// ##################################
	// Get the state of B from the ledger
	// ##################################
	Bvalbytes, err := stub.GetState(B)
	// ##################################
	// NOTE: GetState does not read data from the writeset, which
	// has not been committed to the ledger. In other words, GetState does not
	// consider data modified by PutState that has not been committed.
	if err != nil {
		return shim.Error("Failed to get state")
	}
	if Bvalbytes == nil {
		return shim.Error("Entity not found")
	}
	Bval, _ = strconv.Atoi(string(Bvalbytes))

	// ##################################
	// # Sets the number of units to send
	// ##################################
	Xunits, err = strconv.Atoi(args[2])
	// ##################################
	if err != nil {
		return shim.Error("Invalid transaction amount, expecting a integer value")
	}
	// ##################################
	// # Execute transation
	Aval = Aval - Xunits
	Bval = Bval + Xunits
	// ##################################
	fmt.Printf("Aval = %d, Bval = %d\n", Aval, Bval)

	// #######################################
	// Write the state of A back to the ledger
	// #######################################
	err = stub.PutState(A, []byte(strconv.Itoa(Aval)))
	// ##################################
	// NOTE: PutState puts the specified `key` and `value` into the transaction's
	// writeset as a data-write PROPOSAL. PutState doesn't effect the ledger
	// until the transaction is validated and successfully committed.

	if err != nil {
		return shim.Error(err.Error())
	}

	// #######################################
	// Write the state of A back to the ledger
	// #######################################
	err = stub.PutState(B, []byte(strconv.Itoa(Bval)))
	// ##################################
	// NOTE: PutState puts the specified `key` and `value` into the transaction's
	// writeset as a data-write PROPOSAL. PutState doesn't effect the ledger
	// until the transaction is validated and successfully committed.

	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

// query callback representing the query of a chaincode
func (t *SimpleChaincode) query(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var A string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	A = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(A)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + A + "\"}"
		return shim.Error(jsonResp)
	}

	jsonResp := "{\"Name\":\"" + A + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success(Avalbytes)
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
