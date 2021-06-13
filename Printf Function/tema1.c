#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

static int write_stdout(const char *token, int length)
{
	int rc;
	int bytes_written = 0;

	do {
		rc = write(1, token + bytes_written, length - bytes_written);
		if (rc < 0)
			return rc;

		bytes_written += rc;
	} while (bytes_written < length);

	return bytes_written;
}

static char* convert(long n, char* str, int base){
    // function that converts an integer into a string in a given base;

    int i = 0, flag = 0, start = 0, end; 
  
    if (n == 0){

        str[i] = '0'; 
		i++;
        str[i] = '\0'; 
        return str; 
    } 

    // if the integer is negative and the base is 10 we multiple it with -1;
    // we will add the minus at the end of the string before we reverse it;
    if (base == 10){
  
        if (n < 0){
           
            flag = 1;
            n = n * (-1); 
        }
    }

    // if the integer is negative and the base is 16, 
    // we will construct the 2's complement;

    else{

        if (n < 0){
     
            flag = 1;
            n = 4294967295 + n + 1;
            // 4294967295 represent the maximum number that can be written 
            // in hexadecimal on 8 bits;
        }
    }
 
    //we will construct the mirror image of the integer in our string;
    while (n != 0){ 
        
        int j = n % base; 

        if (j > 9){
                       
            str[i] = 'a' + (j - 10);            
        }

        else{
               
            str[i] = '0' + j;
            
        }

	    i++; 
        n = n / base; 
    }    

    if (base == 10){  

        if (flag == 1){ 
    
            str[i] = '-'; 
            i++;
        }
    }
    
    str[i] = '\0'; // append the null character;

    // reverse the string, without the null character;
    end = strlen(str) - 1;    

    while (start < end){ 

        char aux = str[start];
        str[start] = str[end];
        str[end] = aux;
        start++; 
        end--; 
    } 

    return str; 
} 

int iocla_printf(const char *format, ...){	

    int i = 0, count = 0; // count will return the number of the writtem bytes;
    char *write = malloc(50 * sizeof(char)); // the string that will be printed;

	va_list arg; //hold information about variable arguments;
	va_start(arg, format); // Initializing a variable argument list;

	for (i = 0; format[i] != '\0'; i++){

		if (format[i] == '%'){

            i++;

            if (format[i] == '%'){
                count = count + write_stdout(&(format[i-1]),1);
            }

            // the case when we have to print an int;
			if (format[i] == 'd'){

				int integer = va_arg(arg, int);                
				convert(integer, write, 10);	
                count = count + write_stdout(write, strlen(write));		
			}

            // the case when we have to print an unsigned int;
            if (format[i] == 'u'){

				unsigned int  unsigned_integer = va_arg(arg, unsigned int);

                if (unsigned_integer < 0){

                    unsigned_integer = unsigned_integer * (-1);
                }

				convert(unsigned_integer, write, 10);
				count = count + write_stdout(write, strlen(write));		
			}

            // the case when we have to print an int in hexademcimal;
            if (format[i] == 'x'){

				long hex = va_arg(arg, int);
                convert(hex, write, 16);	
				count = count + write_stdout(write, strlen(write));		
			}

            // the case when we have to print a character;
            if (format[i] == 'c'){

				char c = va_arg(arg, int);	
				count = count + write_stdout(&c, 1);	
			}  

            // the case when we have to print an unsigned int;
            if (format[i] == 's'){

                char *s = va_arg(arg, char*);
				count = count + write_stdout(s, strlen(s));	
            }
        
		}

        else {
            count = count + write_stdout(&format[i],1);
        }

    }

    va_end(arg);  // ending using variable argument list;
    return count;    
}

 int main(){  
  	  

 }