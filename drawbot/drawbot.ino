int sleep = 5;
byte stepper1 = 0b0011;
byte stepper2 = 0b0011;
int CLOCKPIN = 4;
int SERIALPIN = 3;

void setup(){
  pinMode(SERIALPIN,OUTPUT);
  pinMode(CLOCKPIN,OUTPUT);
}

void clock(){
  digitalWrite(CLOCKPIN,HIGH);
  digitalWrite(CLOCKPIN,LOW);
}

void shiftCoils(byte coils){
  for(int n=0; n<8;n++){
    digitalWrite(SERIALPIN, 0b1 ^ ((coils >> n) & 1) );
    clock();
  }
}

//move steppers 1 and 2 +/- 1/0 steps
void nextStep(int move1, int move2){
  

  if (move1 == 1){
    //wrap 1st four bits in register forward 1 step
    stepper1 = (stepper1 >> 1) + ((stepper1 & 0b0001) << 3);
  }
  if (move1 == -1) {
    stepper1 = ((stepper1 << 1) & 0b1111) + ((stepper1 >> 3));
  }
  
  if (move2 == 1){
    //wrap 2nd four bits in register forward 1 step
    stepper2 = (stepper2 >> 1) + ((stepper2 & 0b0001) << 3);
  }
  if (move2 == -1) {
    stepper2 = ((stepper2 << 1) & 0b1111) + (stepper2 >> 3);
  }
  
  shiftCoils(( stepper1 << 4) + stepper2 );
}

void loop(){
  nextStep(1,1);
  delay(1000);
}
