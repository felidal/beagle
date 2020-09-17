#   Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA

#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
 
#       http://www.apache.org/licenses/LICENSE-2.0
 
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

module BaseType
    
    attr_accessor :name, :variables, :accessor, :inheritFrom, :package, :sameFileTypes, :type

    def initialize(params = {})
        @type = nil # setting this to something else will overwrite @templateHelper.defaultDeclarationType in the templates
        @name = params.fetch(:name, '')
        @variables = params.fetch(:variables, [])
        @accessor = params.fetch(:accessor, "public")
        @inheritFrom = params.fetch(:inheritFrom, [])
        @package = params.fetch(:package, "")
        @sameFileTypes = params.fetch(:sameFileTypes, [])
    end
    
end