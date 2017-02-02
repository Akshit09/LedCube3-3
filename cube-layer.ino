int i,j;
int a[16];
int b[4]={42,43,44,45};

// the setup function runs once when you press reset or power the board
void setup() 
{
  for(i=22,j=0;i<=37;i++,j++)
    a[j]=i;
    
  for(j=0;j<=15;j++){
  pinMode(a[j], OUTPUT);
  digitalWrite(a[j],1);}
  for(j=0;j<=3;j++){
    pinMode(b[j], OUTPUT);
  digitalWrite(b[j],0);}
  }

// the loop function runs over and over again forever
void loop() 
{
  
    i=random(22,37);
    j=random(42,45);
    digitalWrite(i,0);
    digitalWrite(j,1);
    delay(500);
    digitalWrite(i,1);
    digitalWrite(j,0);
}
