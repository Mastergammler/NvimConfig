typedef struct {
  int val;
  int flags;
} MyStruct;

void myFunction() {
  MyStruct *str = {};
  str.val = 5;
  str.flags = 0x1;

  MyStruct *other = {};
  other.val = 7;
  other.flags = 5;
}

void otherFunction() {
  MyStruct str = {};
  str.flags = 0b101001;
  str.val = 7;
}
