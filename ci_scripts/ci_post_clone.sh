#!/bin/sh

#  ci_post_clone.sh
#  Browoser
#
#  Created by りん on 12/7/2024.
#

if [[-n $GEMINI_API_KEY]];
then
    cd "Browoser Watch App/APIKey"
    /usr/libexec/PlistBuddy "GenerativeAI-Info.plist"
    /usr/libexec/PlistBuddy -c "add API_KEY string $GEMINI_API_KEY" GenerativeAI-Info.plist
fi
