#ifndef HTTP_SERVER_H
#define HTTP_SERVER_H

void sendGETresponse(int fd, char strFilePath[], char strResponse[]);
void sendPUTresponse(int fd, char strFilePath[], char strBody[], char strResponse[]);
int CreateHTTPserver();

extern char HTTP_200HEADER[];
extern char HTTP_201HEADER[];
extern char HTTP_404HEADER[];
extern char HTTP_400HEADER[];

#endif

