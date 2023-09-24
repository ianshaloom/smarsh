class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateProductException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllProductException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateProductException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteProductException extends CloudStorageException {}
