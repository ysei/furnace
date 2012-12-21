module Furnace::SSA
  class BasicBlock
    attr_reader   :function, :label

    attr_accessor :instructions

    alias :insns  :instructions
    alias :insns= :instructions=

    def initialize(function, insns=[], label=function.make_label)
      @function, @label, @instructions = function, label, insns
    end

    def control_transfer_instruction
      @instructions.last
    end

    def successor_labels
      control_transfer_instruction.uses.
        select do |value|
          value.type == BasicBlock
        end.map do |value|
          value.value
        end
    end

    def successors
      successor_labels.map do |label|
        @function.find(label)
      end
    end

    def predecessor_labels
      predecessors.map(&:label)
    end

    def predecessors
      @function.predecessors_for(self)
    end

    def returns?
      successor_labels.empty?
    end

    def to_value
      Immediate.new(@label, BasicBlock)
    end

    def self.inspect_as_type
      'label'
    end

    def inspect
      string = "#{@label}:\n"

      string << @instructions.map do |insn|
                  "    #{insn.inspect}"
                end.join("\n")

      string
    end
  end
end