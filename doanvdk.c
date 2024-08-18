/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/8/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega16.h>

#include <delay.h>
#include <string.h>
#include <math.h>
#include <stdio.h>
    
unsigned int nhiet; // nhiet do do duoc cho vi tri 1
unsigned int canhbao = 0; // canh bao (=0 nêu khong co cam bien bao loi, = 1 nêu 1 trong 2 cam bien bao)
unsigned int baochay = 0; // = 0 neu chua co chay, = 1 neu có chay
unsigned int xulychay = 0; // = 0 neu chay chua duoc xu ly, = 1 neu da duoc xu ly
unsigned int baocoi = 0; // =0 neu chua xac nhan, = 1 neu da xac nhan
unsigned int dangbaocoi = 0; // =0 neu chua bao coi, = 1 neu da bao coi

unsigned int nhiet1; // nhiet do do duoc cho vi tri 1
unsigned int canhbao1 = 0; // canh bao (=0 nêu khong co cam bien bao loi, = 1 nêu 1 trong 2 cam bien bao)
unsigned int baochay1 = 0; // = 0 neu chua co chay, = 1 neu có chay
unsigned int xulychay1 = 0; // = 0 neu chay chua duoc xu ly, = 1 neu da duoc xu ly
unsigned int baocoi1 = 0; // =0 neu chua xac nhan, = 1 neu da xac nhan
unsigned int dangbaocoi1 = 0; // =0 neu chua bao coi, = 1 neu da bao coi

unsigned int cht = 0; // chon hien thi dia diem chay
unsigned int pn = 0; // khai bao bit nho co phim nhan, pn = 0 co phim nhan, pn = 1 tat ca cac phim deu nha
unsigned char Mang[20];

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here

// Voltage Reference: AREF pin
#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}

void nhietdo()
{
    nhiet = 500 * (unsigned long)read_adc(0) / 1023;
    nhiet1 = 500 * (unsigned long)read_adc(1) / 1023;
}

//========================================



void kiemtra()
{  
   nhietdo(); 
   if(nhiet > 70)
   {
      if(xulychay == 0) // khi chua duoc xu ly 
      {
         PORTC.3 = 1;
         if(baocoi == 0)
         {
            PORTD.0 = 1;
            dangbaocoi = 1;
         }
      }
      baochay = 1;
      canhbao = 1;
   }
   else
   {
      if(xulychay == 1)
      {
         xulychay = 0;
         baochay = 0;
      }
   }
   //---------------------------------------- 
   if(nhiet1 > 70)
   {
      if(xulychay1 == 0) // khi chua duoc xu ly 
      {
         PORTC.2 = 1;
         if(baocoi1 == 0)
         {
            PORTD.0 = 1;
            dangbaocoi1 = 1;
         }
      }
      baochay1 = 1;
      canhbao1 = 1;
   }
   else
   {
      if(xulychay1 == 1)
      {
         xulychay1 = 0;
         baochay1 = 0;
      }
   }
}

void quetphim() // chuong trinh con quet nut nhan / quet phim nhan
{
   if (pn)
   {
      if (PINC.0 == 0)
      {
         pn = 0; // bao co nut duoc nhan
         if(dangbaocoi == 1)
         {
            PORTD.0 = 0;
            baocoi = 1;
         }
         if(baocoi == 1 && canhbao == 0)
         {
            baocoi = 0;
            dangbaocoi = 0;
         }
         
         if(dangbaocoi1 == 1)
         {
            PORTD.0 = 0;
            baocoi1 = 1;
         }
         if(baocoi1 == 1 && canhbao1 == 0)
         {
            baocoi1 = 0;
            dangbaocoi1 = 0;
         }
       }
//----------------------------------------
      if (PINC.1 == 0)
      {
         pn = 0;
         //if(canh_bao>0)
         {
            
            if(cht == 0)
            {
               baochay = 0;
               canhbao = 0;
               kiemtra();
               if(xulychay == 0)
               {
                  xulychay = 1; // bao da xu ly chay
                  PORTC.3 = 0; // tat relay
                  PORTD.0 = 0; // tat coi
                  baocoi=0;
                  dangbaocoi = 0;
               }
               else
               {
                  xulychay = 0;
               }
               if(baochay == 0) // khi van con bao chay
               {
                  xulychay = 0; // bao da xu ly chay
                  PORTC.3 = 0; // tat relay
                  PORTD.0 = 0; // tat coi
                  baocoi = 0;
                  dangbaocoi = 0;
               }
            }
         }
         {
            
            if(cht==1)
            {
               baochay1 = 0;
               canhbao1 = 0;
               kiemtra();
               if(xulychay1 == 0)
               {
                  xulychay1 = 1; // bao da xu ly chay
                  PORTC.2 = 0; // tat relay
                  PORTD.0 = 0; // tat coi
                  baocoi1 = 0;
                  dangbaocoi1 = 0;
               }
               else
               {
                  xulychay1 = 0;
               }
               if(baochay1 == 0) // khi van con bao chay
               {
                  xulychay1 = 0; // bao da xu ly chay
                  PORTC.2 = 0; // tat relay
                  PORTD.0 = 0; // tat coi
                  baocoi1 = 0;
                  dangbaocoi1 = 0;
               }
            }
         }
      }
//---------------------------------------- 
   }
   else
   {
      if((PINC.0 == 1)&&(PINC.1 == 1))
      {
         pn = 1; // bao khong co nut nhan 
      }
   }
}

void taotre2(unsigned int t)
{
   unsigned int i;
   unsigned int j;
   for(i = 0; i < t; i++)
   {
      for(j = 0; j < 40; j++)
      {
         delay_ms(10);
         quetphim();
      }
      nhietdo();
      kiemtra();
      if((canhbao == 0 && cht == 0)||(canhbao1 == 0 && cht == 1)) break;
   }
}
//======================================== 
void taotre(unsigned int t)
{
   unsigned int i;
   unsigned int j;
   for(i = 0; i < t; i++)
   {
      for(j = 0; j < 50; j++)
      {
         delay_ms(10);
         quetphim();
      }
      nhietdo();
      kiemtra();
      if(canhbao == 1||canhbao1 == 1) break;
   }
}
//======================================== 

void hienthichay()
{
   unsigned int xl;
   if((xulychay == 0 && cht == 0)||(xulychay1 == 0 && cht == 1))
   {
      for(xl = 6; xl > 0; xl--)
      { 
         sprintf(Mang,"CHAY - XU LY: %d  ",xl);
         lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;   
         lcd_puts(Mang);
         taotre2(2);
      }
   }
   if((xulychay == 1 && cht == 0)||(xulychay1 == 1 && cht == 1))
   {
      for(xl = 6; xl > 0; xl--)
      {  
         sprintf(Mang,"BAO XU LY LAI: %d  ",xl);
         lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1; 
         lcd_puts(Mang);
         taotre2(2);
      }
   }
}
//========================================
void htnhiet(unsigned int n)
{ 
   if(n < 50)
   {
      sprintf(Mang,"AN TOAN     %02d%cC", n, 0xdf); 
      lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
      lcd_puts(Mang);
   }
   else
   if(n < 70)
   {
      sprintf(Mang,"NGUY HIEM   %02d%cC", n, 0xdf);
      lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
      lcd_puts(Mang);
      PORTD.0 = 1; // bat coi
      taotre(1);
      taotre(1);
      taotre(1);
      PORTD.0 = 0; // tat coi
   }
   else
   if(n >= 70)
   {
      sprintf(Mang,"CO CHAY     %02d%cC", n, 0xdf);
      lcd_gotoxy(0,1); // dua con tro LCD ve dong 1 cot 1;
      lcd_puts(Mang);
      taotre(1);
      taotre(1);
      taotre(1);
      taotre(1);
   }
}
//======================================== 

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: Free Running
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (1<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 7
// RD - PORTD Bit 6
// EN - PORTD Bit 5
// D4 - PORTD Bit 4
// D5 - PORTD Bit 3
// D6 - PORTD Bit 2
// D7 - PORTD Bit 1
// Characters/line: 16

lcd_init(16);
    lcd_clear();
    lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
    lcd_puts("HE THONG PHONG ");
    lcd_gotoxy(0,1); 
    lcd_puts("CHAY CHUA CHAY ");
    delay_ms(1500); 

while (1)
      {
      nhietdo();
      if(canhbao == 0 && canhbao1 == 0)
      {
         lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
         lcd_puts("PHONG SO 01     ");
         htnhiet(nhiet);
         taotre(6);
         lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
         lcd_puts("PHONG SO 02     ");
         htnhiet(nhiet1);
         taotre(6);
      }
      if(canhbao == 1 || canhbao1 == 1)
      {
         cht = 0;
         lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
         lcd_puts("PHONG SO 01     ");
         if(baochay)
            hienthichay();
         else
         {
            htnhiet(nhiet);
            taotre(6);
         }
         cht = 1;
         lcd_gotoxy(0,0); // dua con tro LCD ve dong 1 cot 1;
         lcd_puts("PHONG SO 02     ");
         if(baochay1)
            hienthichay();
         else
         {
            htnhiet(nhiet1);
            taotre(6);
         }


      }

      }
}
