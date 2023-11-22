class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateException extends CloudStorageException {}

// R in CRUD
class CouldNotGetAllException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteException extends CloudStorageException {}

// GenericCloudException

class GenericCloudException extends CloudStorageException {}