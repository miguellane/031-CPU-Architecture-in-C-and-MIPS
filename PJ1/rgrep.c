#include <stdio.h>
#define MAXSIZE 4096

int matches_leading(char *partial_line, char *pattern) {
  int jump = 0;
  if(pattern[0]=='\0'){
	  return 1;
  }else if(pattern[0]=='\\'){
    if(partial_line[0]==pattern[1])
	  jump = 2;
  }else if(pattern[0]=='.'&&partial_line[0]!='\0'){
	jump = 1;
  }else if((pattern[0]>64&&pattern[0]<91)||(pattern[0]>96&&pattern[0]<123)){
    if(partial_line[0]==pattern[0])
	  jump = 1;
  }else if(pattern[1] == '?'){
	  return matches_leading(&partial_line[0],&pattern[2]);
  }
// change into modifying wildcards
  if(pattern[jump] == '+'){
	  if(partial_line[1]==pattern[jump-1]||(pattern[0]=='.'&&partial_line[0]!='\0'))
	    return matches_leading(&partial_line[1],&pattern[0]);
	  else
		return matches_leading(&partial_line[1],&pattern[2]);
  }else if(pattern[jump] == '?'){
	  jump += 1;
	  return matches_leading(&partial_line[1],&pattern[jump]);
  }else if(jump != 0){
	  return matches_leading(&partial_line[1],&pattern[jump]);
  }
  return 0;
}
int rgrep_matches(char *line, char *pattern) {
  int i;
  for(i=0;i<sizeof(line);i++){
    if(matches_leading(&line[i],pattern)==1)
      return 1;		
  }
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
        return 2;
    }

    /* we're not going to worry about long lines */
    char buf[MAXSIZE];

    while (!feof(stdin) && !ferror(stdin)) {
        if (!fgets(buf, sizeof(buf), stdin)) {
            break;
        }
        if (rgrep_matches(buf, argv[1])) {
            fputs(buf, stdout);
            fflush(stdout);
        }
    }

    if (ferror(stdin)) {
        perror(argv[0]);
        return 1;
    }

    return 0;
}
